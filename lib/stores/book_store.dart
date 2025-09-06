import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tramatec_app/models/book_model.dart';
import 'package:tramatec_app/models/carousel_model.dart';

part 'book_store.g.dart';

// ignore: library_private_types_in_public_api
class BookStore = _BookStore with _$BookStore;

abstract class _BookStore with Store {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @observable
  ObservableList<Carousel> carousels = ObservableList<Carousel>();

  @observable
  bool isLoading = false;

  List<List<T>> chunkList<T>(List<T> list, int chunkSize) {
    final List<List<T>> chunks = [];
    for (var i = 0; i < list.length; i += chunkSize) {
      final end = (i + chunkSize < list.length) ? i + chunkSize : list.length;
      chunks.add(list.sublist(i, end));
    }
    return chunks;
  }

  @action
  Future<void> fetchHomeScreenData() async {
    isLoading = true;
    try {
      final carouselsSnapshot =
          await _firestore.collection('carousels').orderBy('order').get();

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
}
