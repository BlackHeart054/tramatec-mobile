import 'package:cloud_firestore/cloud_firestore.dart';
import 'book_model.dart';

class Carousel {
  final String id;
  final String title;
  final int order;
  final List<String> bookIds;
  final List<Book> books;

  Carousel({
    required this.id,
    required this.title,
    required this.order,
    required this.bookIds,
    this.books = const [],
  });

  factory Carousel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot, [
    List<Book> books = const [],
  ]) {
    final data = snapshot.data();
    if (data == null) {
      throw StateError('Documento Carousel ${snapshot.id} está vazio.');
    }
    return Carousel(
      id: snapshot.id,
      title: data['title'] ?? '',
      order: data['order'] ?? 0,
      bookIds: List<String>.from(data['books'] ?? []),
      books: books,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'order': order,
      'books': bookIds,
    };
  }
}
