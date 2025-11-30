import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tramatec_app/config/service_locator.dart';
import 'package:tramatec_app/custom_widgets/book_card.dart';
import 'package:tramatec_app/custom_widgets/epub_reader.dart';
import 'package:tramatec_app/models/book_model.dart';
import 'package:tramatec_app/stores/book_store.dart';

enum BookSectionType { favorites, bookmarks }

class SectionBooksScreen extends StatefulWidget {
  final String title;
  final BookSectionType sectionType;

  const SectionBooksScreen({
    super.key,
    required this.title,
    required this.sectionType,
  });

  @override
  State<SectionBooksScreen> createState() => _SectionBooksScreenState();
}

class _SectionBooksScreenState extends State<SectionBooksScreen> {
  final BookStore bookStore = getIt<BookStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C101C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C101C),
        elevation: 0,
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Observer(
        builder: (_) {
          List<Book> booksToShow;
          String emptyMessage;
          IconData emptyIcon;

          if (widget.sectionType == BookSectionType.favorites) {
            booksToShow = bookStore.favorites;
            emptyMessage = "Você ainda não favoritou nenhum livro.";
            emptyIcon = Icons.favorite_border;
          } else {
            booksToShow = bookStore.bookmarks;
            emptyMessage = "Nenhum livro marcado para ler.";
            emptyIcon = Icons.bookmark_border;
          }

          if (bookStore.isLoading && booksToShow.isEmpty) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          }

          if (booksToShow.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(emptyIcon, size: 60, color: Colors.white24),
                  const SizedBox(height: 16),
                  Text(
                    emptyMessage,
                    style: const TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: booksToShow.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 0.55,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              final book = booksToShow[index];
              return BookCard(
                book: book,
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
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(e.toString()),
                            backgroundColor: Colors.red),
                      );
                    }
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
