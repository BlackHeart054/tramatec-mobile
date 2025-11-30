import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tramatec_app/config/service_locator.dart';
import 'package:tramatec_app/custom_widgets/book_card.dart';
import 'package:tramatec_app/custom_widgets/epub_reader.dart';
import 'package:tramatec_app/stores/book_store.dart';

class LibraryScreen extends StatefulWidget {
  static const route = '/library';
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final BookStore bookStore = getIt<BookStore>();

  @override
  void initState() {
    super.initState();
    bookStore.fetchUserLibrary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C101C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C101C),
        elevation: 0,
        title: const Text('Minha Biblioteca',
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Observer(
        builder: (_) {
          if (bookStore.isLoading && bookStore.myLibrary.isEmpty) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          }

          if (bookStore.myLibrary.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.library_books_outlined,
                      size: 60, color: Colors.white24),
                  SizedBox(height: 16),
                  Text(
                    'Sua biblioteca está vazia.',
                    style: TextStyle(color: Colors.white54),
                  ),
                  Text(
                    'Explore livros e comece a ler!',
                    style: TextStyle(color: Colors.white24, fontSize: 12),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookStore.myLibrary.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 0.55,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              final book = bookStore.myLibrary[index];
              return BookCard(
                book: book,
                onTap: () async {
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
                },
              );
            },
          );
        },
      ),
    );
  }
}
