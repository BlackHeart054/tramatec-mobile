import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String id;
  final String title;
  final String coverUrl;
  final String authorId;
  final String synopsis;
  final String? authorName;
  final String? downloadUrl;
  final bool isExternal;

  Book({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.authorId,
    required this.synopsis,
    this.authorName,
    this.isExternal = false,
    this.downloadUrl,
  });

  factory Book.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) throw StateError('Vazio');
    return Book(
      id: snapshot.id,
      title: data['title'] ?? '',
      coverUrl: data['coverUrl'] ?? '',
      authorId: data['authorId'] ?? '',
      synopsis: data['synopsis'] ?? '',
      authorName: data['authorName'],
      downloadUrl: data['downloadUrl'],
      isExternal: false,
    );
  }

  factory Book.fromGutendex(Map<String, dynamic> json) {
    String cover = 'https://via.placeholder.com/150';
    final formats = json['formats'] as Map<String, dynamic>?;

    if (formats != null) {
      if (formats.containsKey('image/jpeg')) {
        cover = formats['image/jpeg'];
      } else if (formats.containsKey('image/png')) {
        cover = formats['image/png'];
      }
    }
    String author = 'Autor Desconhecido';
    String extAuthorId = 'unknown';

    final authorsList = json['authors'] as List<dynamic>?;
    if (authorsList != null && authorsList.isNotEmpty) {
      final firstAuthor = authorsList[0];
      author = firstAuthor['name'] ?? 'Autor Desconhecido';
      if (author.contains(',')) {
        final parts = author.split(',');
        if (parts.length >= 2) {
          author = "${parts[1].trim()} ${parts[0].trim()}";
        }
      }
      extAuthorId = (firstAuthor['birth_year'] ?? 0).toString();
    }

    String generatedSynopsis = "Sinopse indisponível.";
    final List<dynamic>? subjects = json['subjects'];
    if (subjects != null && subjects.isNotEmpty) {
      final cleanSubjects = subjects.map((s) => s.toString()).take(5).toList();
      generatedSynopsis =
          "Principais Temas:\n\n• ${cleanSubjects.join('\n• ')}";
    }

    String? epubUrl;
    if (formats != null) {
      epubUrl = formats['application/epub+zip'] ??
          formats['application/epub+zip.noimages'];

      if (epubUrl == null) {
        for (var val in formats.values) {
          if (val.toString().endsWith('.epub')) {
            epubUrl = val.toString();
            break;
          }
        }
      }
    }

    return Book(
      id: json['id'].toString(),
      title: json['title'] ?? 'Sem Título',
      coverUrl: cover,
      authorId: extAuthorId,
      authorName: author,
      synopsis: generatedSynopsis,
      isExternal: true,
      downloadUrl: epubUrl,
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
      isExternal: isExternal,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'coverUrl': coverUrl,
      'authorId': authorId,
      'synopsis': synopsis,
      'authorName': authorName,
      'downloadUrl': downloadUrl,
    };
  }
}
