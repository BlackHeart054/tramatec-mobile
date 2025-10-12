import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../config/service_locator.dart';
import '../custom_widgets/book_carousel.dart';
import '../stores/book_store.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (bookStore.isLoading && bookStore.carousels.isEmpty) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.white));
        }
        if (bookStore.carousels.isEmpty) {
          return const Center(
              child: Text("Nenhum conteúdo disponível",
                  style: TextStyle(color: Colors.white)));
        }
        return ListView.builder(
          itemCount: bookStore.carousels.length,
          itemBuilder: (context, index) {
            final carousel = bookStore.carousels[index];
            return BookCarousel(title: carousel.title, books: carousel.books);
          },
        );
      },
    );
  }
}
