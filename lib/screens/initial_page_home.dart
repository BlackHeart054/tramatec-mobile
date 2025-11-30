import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tramatec_app/config/service_locator.dart';
import 'package:tramatec_app/custom_widgets/book_card.dart';
import 'package:tramatec_app/custom_widgets/epub_reader.dart';
import 'package:tramatec_app/models/book_model.dart';
import 'package:tramatec_app/screens/explore_screen.dart';
import 'package:tramatec_app/stores/book_store.dart';

class InitialPageContent extends StatefulWidget {
  const InitialPageContent({super.key});

  @override
  State<InitialPageContent> createState() => _InitialPageContentState();
}

class _InitialPageContentState extends State<InitialPageContent> {
  late final BookStore bookStore;

  @override
  void initState() {
    super.initState();
    bookStore = getIt<BookStore>();
    bookStore.fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (bookStore.isLoading && bookStore.myLibrary.isEmpty) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.white));
        }

        Book? lastReadBook;
        if (bookStore.lastReadBookId != null) {
          try {
            lastReadBook = bookStore.myLibrary
                .firstWhere((b) => b.id == bookStore.lastReadBookId);
          } catch (_) {}
        }

        return RefreshIndicator(
          onRefresh: () async => await bookStore.fetchUserData(),
          backgroundColor: const Color(0xFF191D3A),
          color: const Color(0xFF3F8A99),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 20),
            children: [
              if (lastReadBook != null) ...[
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
                  child: Text(
                    "Retomar Leitura",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                _buildContinueReadingCard(lastReadBook),
              ],
              if (bookStore.myLibrary.isNotEmpty)
                _buildHorizontalSection(
                    "Minha Biblioteca", bookStore.myLibrary),
              if (bookStore.favorites.isNotEmpty)
                _buildHorizontalSection("Favoritos", bookStore.favorites),
              if (bookStore.bookmarks.isNotEmpty)
                _buildHorizontalSection(
                    "Marcados para Ler", bookStore.bookmarks),
              if (bookStore.myLibrary.isEmpty &&
                  bookStore.favorites.isEmpty &&
                  bookStore.bookmarks.isEmpty)
                Container(
                  height: 300,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.menu_book,
                          size: 60, color: Colors.white24),
                      const SizedBox(height: 16),
                      const Text(
                        "Sua estante está vazia.",
                        style: TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Vá para a aba 'Explorar' para adicionar livros!")),
                          );
                        },
                        child: const Text("Explorar Livros"),
                      )
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContinueReadingCard(Book book) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 140,
      decoration: BoxDecoration(
        color: const Color(0xFF191D3A),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            try {
              final Uint8List bytes = await bookStore.openBook(book);
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        EpubReaderPage(epubData: bytes, bookId: book.id),
                  ),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(e.toString()), backgroundColor: Colors.red));
              }
            }
          },
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12)),
                child: book.coverUrl.startsWith('http')
                    ? Image.network(book.coverUrl,
                        width: 90, height: 140, fit: BoxFit.cover)
                    : Image.asset(book.coverUrl,
                        width: 90, height: 140, fit: BoxFit.cover),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(book.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(book.authorName ?? "",
                          style: const TextStyle(
                              color: Colors.white54, fontSize: 12)),
                      const Spacer(),
                      Row(
                        children: const [
                          Icon(Icons.play_circle_fill,
                              color: Color(0xFF3F8A99), size: 20),
                          SizedBox(width: 8),
                          Text("CONTINUAR",
                              style: TextStyle(
                                  color: Color(0xFF3F8A99),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalSection(String title, List<Book> books) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 340,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return BookCard(
                book: book,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => BookPreviewSheet(book: book),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
