import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tramatec_app/config/service_locator.dart';
import 'package:tramatec_app/custom_widgets/epub_reader.dart';
import 'package:tramatec_app/models/book_model.dart';
import 'package:tramatec_app/custom_widgets/book_card.dart';
import 'package:tramatec_app/stores/book_store.dart';

final List<Book> exploreBooks = [
  Book(
    title: 'Duna',
    authorName: 'Frank Herbert',
    coverUrl: 'assets/images/book_1.png',
    authorId: '1',
    id: '1',
    synopsis:
        'Em um futuro distante, o deserto do planeta Arrakis é a chave para o poder galáctico, pois abriga a valiosa especiaria Melange. Paul Atreides precisa enfrentar traições, intrigas políticas e o próprio destino para se tornar o messias de um povo oprimido.',
  ),
  Book(
    title: 'O Problema dos 3 Corpos',
    authorName: 'Cixin Liu',
    coverUrl: 'assets/images/book_2.png',
    authorId: '2',
    id: '2',
    synopsis:
        'Durante a Revolução Cultural Chinesa, uma cientista faz contato com uma civilização alienígena que enfrenta um sistema solar caótico. Décadas depois, a humanidade começa a perceber as consequências desse primeiro contato — e a possível invasão que se aproxima.',
  ),
  Book(
    title: 'Neuromancer',
    authorName: 'William Gibson',
    coverUrl: 'assets/images/book_3.png',
    authorId: '3',
    id: '3',
    synopsis:
        'Case, um hacker decadente, é recrutado por um misterioso empregador para uma missão impossível no ciberespaço. Em um mundo dominado por megacorporações e inteligências artificiais, ele se envolve em uma conspiração que redefine os limites entre homem e máquina.',
  ),
  Book(
    title: 'Os Sete Maridos de Evelyn Hugo',
    authorName: 'Taylor Jenkins Reid',
    coverUrl: 'assets/images/book_4.png',
    authorId: '4',
    id: '4',
    synopsis:
        'A lendária estrela de Hollywood Evelyn Hugo decide contar sua história — cheia de glamour, segredos e sete casamentos — a uma jovem jornalista. Mas o motivo de sua escolha é mais profundo e pessoal do que qualquer um poderia imaginar.',
  ),
  Book(
    title: 'A Paciente Silenciosa',
    authorName: 'Alex Michaelides',
    coverUrl: 'assets/images/book_5.png',
    authorId: '5',
    id: '5',
    synopsis:
        'Após atirar no marido e se recusar a falar desde então, a pintora Alicia Berenson é internada em um hospital psiquiátrico. Um psicoterapeuta obcecado por seu caso tenta descobrir o que realmente aconteceu — e acaba mergulhando em um mistério cheio de reviravoltas.',
  ),
  Book(
    title: 'É Assim que Acaba',
    authorName: 'Colleen Hoover',
    coverUrl: 'assets/images/book_6.png',
    authorId: '6',
    id: '6',
    synopsis:
        'Lily Bloom acredita ter encontrado o amor perfeito em Ryle, um cirurgião encantador. Mas quando comportamentos do passado começam a reaparecer, ela é forçada a enfrentar escolhas dolorosas sobre amor, violência e recomeços.',
  ),
  Book(
    title: 'O Homem de Giz',
    authorName: 'C. J. Tudor',
    coverUrl: 'assets/images/book_7.png',
    authorId: '7',
    id: '7',
    synopsis:
        'Em 1986, um grupo de amigos descobre um corpo após seguir desenhos de giz misteriosos. Anos depois, os mesmos símbolos voltam a aparecer, trazendo à tona segredos e traumas que nunca foram totalmente enterrados.',
  ),
  Book(
    title: 'O Guia do Mochileiro das Galáxias',
    authorName: 'Douglas Adams',
    coverUrl: 'assets/images/book_8.png',
    authorId: '8',
    id: '8',
    synopsis:
        'Quando a Terra é demolida para abrir espaço para uma via intergaláctica, Arthur Dent é salvo por um alienígena disfarçado de humano. Juntos, eles embarcam em uma jornada absurda e hilária pelo universo, armados apenas com uma toalha e um guia muito peculiar.',
  ),
  Book(
    title: 'Fahrenheit 451',
    authorName: 'Ray Bradbury',
    coverUrl: 'assets/images/book_9.png',
    authorId: '9',
    id: '9',
    synopsis:
        'Em um futuro distópico onde livros são proibidos e queimados, o bombeiro Montag começa a questionar o sistema que jurou defender. Sua busca por conhecimento o coloca em rota de colisão com um governo que teme o poder das ideias.',
  ),
  Book(
    title: '1984',
    authorName: 'George Orwell',
    coverUrl: 'assets/images/book_10.png',
    authorId: '10',
    id: '10',
    synopsis:
        'Sob o olhar constante do Grande Irmão, Winston Smith vive em uma sociedade onde até o pensamento é controlado. Ao desafiar o regime totalitário da Oceânia, ele descobre o verdadeiro custo da liberdade e da verdade.',
  ),
];

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final BookStore bookStore = getIt<BookStore>();

  @override
  void initState() {
    super.initState();
    if (bookStore.publicDomainBooks.isEmpty) {
      bookStore.fetchGutendexBooks();
    }
  }

  void _showBookPreview(BuildContext context, Book book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BookPreviewSheet(book: book);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            'Domínio Público',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Observer(
            builder: (_) {
              var apiBooks = bookStore.publicDomainBooks.toList();

              if (bookStore.isLoading && apiBooks.isEmpty) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.white));
              }

              apiBooks =
                  bookStore.applySort(apiBooks, bookStore.currentExploreSort);

              if (apiBooks.isEmpty) {
                return const Center(
                    child: Text("Falha ao carregar livros",
                        style: TextStyle(color: Colors.white54)));
              }

              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemCount: apiBooks.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 0.55,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final book = apiBooks[index];
                  return BookCard(
                    book: book,
                    onTap: () => _showBookPreview(context, book),
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

void _showBookPreview(BuildContext context, Book book) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BookPreviewSheet(book: book);
    },
  );
}

@override
Widget build(BuildContext context) {
  final BookStore bookStore = getIt<BookStore>();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Text(
          'Todos os Livros',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Expanded(
        child: Observer(
          builder: (_) {
            final allBooks =
                bookStore.carousels.expand((c) => c.books).toSet().toList();

            if (allBooks.isEmpty && bookStore.isLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.white));
            }

            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              itemCount: allBooks.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 0.55,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final book = allBooks[index];
                return BookCard(
                  book: book,
                  onTap: () => _showBookPreview(context, book),
                );
              },
            );
          },
        ),
      ),
    ],
  );
}

class BookPreviewSheet extends StatelessWidget {
  final Book book;
  const BookPreviewSheet({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final BookStore bookStore = getIt<BookStore>();
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        color: Color(0xFF191D3A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: book.coverUrl.startsWith('http')
                      ? Image.network(
                          book.coverUrl,
                          width: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 100,
                            height: 150,
                            color: Colors.grey.shade800,
                            child: const Icon(Icons.broken_image,
                                color: Colors.white54),
                          ),
                        )
                      : Image.asset(
                          book.coverUrl,
                          width: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 100,
                            height: 150,
                            color: Colors.grey.shade800,
                            child:
                                const Icon(Icons.book, color: Colors.white54),
                          ),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        book.authorId,
                        style: TextStyle(
                            color: Colors.grey.shade400, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'SINOPSE',
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text(
              book.synopsis,
              style: const TextStyle(color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                // 1. Botão LER AGORA
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F8A99),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      navigator.pop();
                      scaffoldMessenger.showSnackBar(const SnackBar(
                          content: Text('Preparando seu livro...')));

                      try {
                        final String path = await bookStore.openBook(book);
                        navigator.push(MaterialPageRoute(
                            builder: (_) => EpubReaderPage(
                                epubPath: path, bookId: book.id)));
                      } catch (e) {
                        scaffoldMessenger.showSnackBar(SnackBar(
                            content: Text(e.toString()),
                            backgroundColor: Colors.red));
                      }
                    },
                    child: book.downloadUrl == null
                        ? const Text('INDISPONÍVEL',
                            style: TextStyle(color: Colors.white54))
                        : const Text('LER AGORA',
                            style: TextStyle(color: Colors.white)),
                  ),
                ),

                const SizedBox(width: 8),

                // 2. Botão FAVORITAR (Coração)
                Observer(builder: (_) {
                  final isFav = bookStore.favorites.any((b) => b.id == book.id);
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF222B45),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.redAccent : Colors.white,
                      ),
                      onPressed: () => bookStore.toggleFavorite(book),
                      tooltip: "Favoritar",
                    ),
                  );
                }),

                const SizedBox(width: 8),

                // 3. Botão MARCAR (Bookmark)
                Observer(builder: (_) {
                  final isMarked =
                      bookStore.bookmarks.any((b) => b.id == book.id);
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF222B45),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(
                        isMarked ? Icons.bookmark : Icons.bookmark_border,
                        color:
                            isMarked ? const Color(0xFF3F8A99) : Colors.white,
                      ),
                      onPressed: () => bookStore.toggleBookmark(book),
                      tooltip: "Marcar para ler",
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
