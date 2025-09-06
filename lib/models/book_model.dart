import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String title;
  final String coverUrl;
  final String authorId;
  final String synopsis;

  final String? authorName;

  Book({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.authorId,
    required this.synopsis,
    this.authorName,
  });

  factory Book.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw StateError('Documento Book ${snapshot.id} está vazio.');
    }
    return Book(
      id: snapshot.id,
      title: data['title'] ?? '',
      coverUrl: data['coverUrl'] ?? '',
      authorId: data['authorId'] ?? '',
      synopsis: data['synopsis'] ?? '',
    );
  }

  Book copyWith({String? authorName}) {
    return Book(
      id: id,
      title: title,
      coverUrl: coverUrl,
      authorId: authorId,
      synopsis: synopsis,
      authorName: authorName ?? this.authorName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'coverUrl': coverUrl,
      'authorId': authorId,
      'synopsis': synopsis,
    };
  }
}
