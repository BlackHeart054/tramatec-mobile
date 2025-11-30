import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'package:tramatec_app/models/book_model.dart';
import 'package:tramatec_app/models/carousel_model.dart';

part 'book_store.g.dart';

enum BookSortOption { relevance, alphabeticalAZ, alphabeticalZA, newest }

// ignore: library_private_types_in_public_api
class BookStore = _BookStore with _$BookStore;

abstract class _BookStore with Store {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @observable
  PackageInfo? packageInfo = PackageInfo(
    appName: 'tramatec',
    packageName: 'tramatec',
    version: '1.0.0',
    buildNumber: '1',
  );

  @observable
  ObservableList<Carousel> carousels = ObservableList<Carousel>();

  @observable
  ObservableList<Book> searchResults = ObservableList<Book>();

  @observable
  ObservableList<Book> favorites = ObservableList<Book>();

  @observable
  ObservableList<Book> bookmarks = ObservableList<Book>();

  @observable
  bool isLoading = false;

  @observable
  bool isSearching = false;

  @observable
  ObservableList<Book> myLibrary = ObservableList<Book>();

  @observable
  String? lastReadBookId;

  @observable
  BookSortOption currentExploreSort = BookSortOption.relevance;

  Timer? _debounceTimer;

  @observable
  ObservableList<Book> publicDomainBooks = ObservableList<Book>();

  final String _gutendexUrl = 'https://gutendex.com/books';

  // final List<Book> _allBooksCache = [];

  List<List<T>> chunkList<T>(List<T> list, int chunkSize) {
    final List<List<T>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      final end = (i + chunkSize < list.length) ? i + chunkSize : list.length;
      chunks.add(list.sublist(i, end));
    }
    return chunks;
  }

  @action
  Future<void> fetchGutendexBooks({String? searchQuery}) async {
    if (searchQuery != null && searchQuery.length < 3) {
      return;
    }

    isLoading = true;
    try {
      String url = _gutendexUrl;
      if (searchQuery != null && searchQuery.isNotEmpty) {
        url += '?search=${Uri.encodeComponent(searchQuery)}';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        final List<Book> externalBooks =
            results.map((json) => Book.fromGutendex(json)).toList();

        if (searchQuery != null && searchQuery.isNotEmpty) {
          searchResults = ObservableList.of(externalBooks);
        } else {
          publicDomainBooks = ObservableList.of(externalBooks);
        }
      } else if (response.statusCode == 429) {
        if (kDebugMode) {
          print("Muitas requisições (429). Aguardando...");
        }
      } else {
        if (kDebugMode) {
          print("Erro na API Gutendex: ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) print("Erro ao buscar livros externos: $e");
    } finally {
      isLoading = false;
      isSearching = false;
    }
  }

  @action
  Future<void> importExternalBook(Book book) async {
    if (!book.isExternal) return;

    try {
      final docId = "gutendex_${book.id}";
      final docRef = _firestore.collection('books').doc(docId);

      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        await docRef.set({
          ...book.toMap(),
          'source': 'gutendex',
          'originalId': book.id,
          'createdAt': FieldValue.serverTimestamp(),
        });
        if (kDebugMode) {
          print("Livro ${book.title} importado para o Firestore!");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erro ao importar livro: $e");
      }
    }
  }

  @action
  Future<void> fetchHomeScreenData() async {
    isLoading = true;
    try {
      // final carouselsSnapshot =
      // await _firestore.collection('carousels').orderBy('order').get();
      final carouselsSnapshot = await _firestore.collection('carousels').get();

      List<Carousel> fetchedCarousels = [];

      for (var doc in carouselsSnapshot.docs) {
        final carouselData = doc.data();
        final List<String> bookIds =
            List<String>.from(carouselData['books'] ?? []);

        List<Book> books = [];

        if (bookIds.isNotEmpty) {
          final chunks = chunkList(bookIds, 10);

          for (var chunk in chunks) {
            final booksSnapshot = await _firestore
                .collection('books')
                .where(FieldPath.documentId, whereIn: chunk)
                .get();

            books.addAll(
              booksSnapshot.docs.map((bookDoc) => Book.fromFirestore(bookDoc)),
            );
          }

          final authorIds = books.map((b) => b.authorId).toSet().toList();
          List<Map<String, dynamic>> authorsData = [];

          final authorChunks = chunkList(authorIds, 10);
          for (var chunk in authorChunks) {
            final authorsSnapshot = await _firestore
                .collection('authors')
                .where(FieldPath.documentId, whereIn: chunk)
                .get();

            authorsData.addAll(authorsSnapshot.docs.map((a) => {
                  "id": a.id,
                  "name": a.data()['name'] ?? '',
                }));
          }

          final authorMap = {
            for (var a in authorsData) a['id']: a['name'],
          };

          books = books
              .map((b) => b.copyWith(authorName: authorMap[b.authorId]))
              .toList();
        }

        fetchedCarousels.add(Carousel.fromFirestore(doc, books));
      }

      carousels = ObservableList.of(fetchedCarousels);
    } catch (e) {
      if (kDebugMode) {
        print("Erro ao buscar dados da home: $e");
      }
    } finally {
      isLoading = false;
    }
  }

  @action
  void setExploreSort(BookSortOption option) {
    currentExploreSort = option;
  }

  List<Book> applySort(List<Book> books, BookSortOption sortOption) {
    List<Book> sortedList = List.from(books);

    switch (sortOption) {
      case BookSortOption.alphabeticalAZ:
        sortedList.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case BookSortOption.alphabeticalZA:
        sortedList.sort(
            (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        break;
      case BookSortOption.newest:
        sortedList.sort((a, b) => b.id.compareTo(a.id));
        break;
      case BookSortOption.relevance:
      default:
        break;
    }
    return sortedList;
  }

  @action
  void searchBooksDebounced(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      searchBooks(query);
    });
  }

  @action
  Future<void> searchBooks(String query,
      {BookSortOption sort = BookSortOption.relevance}) async {
    isSearching = true;

    if (query.isEmpty) {
      clearSearch();
      isSearching = false;
      return;
    }

    await fetchGutendexBooks(searchQuery: query);

    if (searchResults.isNotEmpty) {
      List<Book> sorted = applySort(searchResults.toList(), sort);
      searchResults = ObservableList.of(sorted);
    }
  }

  @action
  Future<void> addToLibrary(Book book) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('library')
          .doc(book.id)
          .set({
        ...book.toMap(),
        'addedAt': FieldValue.serverTimestamp(),
      });

      if (!myLibrary.any((b) => b.id == book.id)) {
        myLibrary.add(book);
      }
      if (kDebugMode) {
        print("Livro adicionado à biblioteca!");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erro ao adicionar à biblioteca: $e");
      }
    }
  }

  @action
  Future<void> fetchUserLibrary() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    isLoading = true;
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('library')
          .orderBy('addedAt', descending: true)
          .get();

      final books =
          snapshot.docs.map((doc) => Book.fromFirestore(doc)).toList();
      myLibrary = ObservableList.of(books);

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists && userDoc.data()!.containsKey('lastBookId')) {
        lastReadBookId = userDoc.data()!['lastBookId'];
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erro ao buscar biblioteca: $e");
      }
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<String> openBook(Book book) async {
    if (book.downloadUrl == null) {
      throw "Este livro não possui arquivo digital disponível.";
    }

    isLoading = true;
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await addToLibrary(book);
        await _firestore.collection('users').doc(user.uid).update({
          'lastBookId': book.id,
        });
        lastReadBookId = book.id;
      }

      Directory appDocDir = await getApplicationDocumentsDirectory();
      String path = '${appDocDir.path}/${book.id}.epub';
      File file = File(path);

      if (!file.existsSync()) {
        await Dio().download(book.downloadUrl!, path);
      }

      if (!File(path).existsSync()) {
        throw "Falha ao baixar o arquivo EPUB.";
      }

      return path;
    } catch (e) {
      throw "Erro ao preparar livro: $e";
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<String> resumeReading() async {
    if (lastReadBookId == null) {
      await fetchUserLibrary();
    }

    if (lastReadBookId != null) {
      try {
        final book = myLibrary.firstWhere((b) => b.id == lastReadBookId,
            orElse: () => throw "Livro não encontrado localmente.");
        return await openBook(book);
      } catch (e) {
        throw "Erro ao retomar leitura: $e";
      }
    } else {
      throw "Você ainda não começou nenhum livro.";
    }
  }

  @action
  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    isLoading = true;
    try {
      await fetchUserLibrary();

      final favSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('favorites')
          .orderBy('addedAt', descending: true)
          .get();
      favorites = ObservableList.of(
          favSnapshot.docs.map((doc) => Book.fromFirestore(doc)).toList());

      final markSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('bookmarks')
          .orderBy('addedAt', descending: true)
          .get();
      bookmarks = ObservableList.of(
          markSnapshot.docs.map((doc) => Book.fromFirestore(doc)).toList());
    } catch (e) {
      if (kDebugMode) print("Erro ao carregar dados do usuário: $e");
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> toggleFavorite(Book book) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final isFav = favorites.any((b) => b.id == book.id);
    final ref = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(book.id);

    if (isFav) {
      await ref.delete();
      favorites.removeWhere((b) => b.id == book.id);
    } else {
      await ref.set({...book.toMap(), 'addedAt': FieldValue.serverTimestamp()});
      favorites.add(book);
    }
  }

  @action
  Future<void> toggleBookmark(Book book) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final isMarked = bookmarks.any((b) => b.id == book.id);
    final ref = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('bookmarks')
        .doc(book.id);

    if (isMarked) {
      await ref.delete();
      bookmarks.removeWhere((b) => b.id == book.id);
    } else {
      await ref.set({...book.toMap(), 'addedAt': FieldValue.serverTimestamp()});
      bookmarks.add(book);
    }
  }

  @action
  void clearSearch() {
    searchResults.clear();
  }
}
