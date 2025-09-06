import 'package:cloud_firestore/cloud_firestore.dart';

class Author {
  final String id;
  final String name;
  final String bio;

  Author({
    required this.id,
    required this.name,
    required this.bio,
  });

  factory Author.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw StateError('Documento Author ${snapshot.id} está vazio.');
    }
    return Author(
      id: snapshot.id,
      name: data['name'] ?? '',
      bio: data['bio'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'bio': bio,
    };
  }
}
