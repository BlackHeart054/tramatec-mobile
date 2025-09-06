import 'package:flutter/material.dart';
import 'package:tramatec_app/custom_widgets/book_card.dart';
import 'package:tramatec_app/models/book_model.dart';

class BookCarousel extends StatelessWidget {
  final String title;
  final List<Book> books;

  const BookCarousel({super.key, required this.title, required this.books});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return BookCard(book: book);
            },
          ),
        ),
      ],
    );
  }
}
