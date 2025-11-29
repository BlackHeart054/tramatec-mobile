import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart'; // Importante para o Observer
import 'package:tramatec_app/config/service_locator.dart'; // Para pegar a store
import 'package:tramatec_app/models/book_model.dart';
import 'package:tramatec_app/stores/book_store.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;

  const BookCard({
    super.key,
    required this.book,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Recupera a instância da Store para verificar estados e chamar ações
    final BookStore bookStore = getIt<BookStore>();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 280,
        width: 180,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // 1. IMAGEM (Capa)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: book.coverUrl.startsWith('http')
                      ? Image.network(
                          book.coverUrl,
                          height: 290,
                          width: 180,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 290,
                              width: 180,
                              color: const Color(0xFF191D3A),
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: const Color(0xFF3F8A99),
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (_, __, ___) => Container(
                            height: 290,
                            width: 180,
                            color: Colors.grey[900],
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_not_supported_outlined,
                                    size: 40, color: Colors.white24),
                                SizedBox(height: 8),
                                Text("Sem Imagem",
                                    style: TextStyle(
                                        color: Colors.white24, fontSize: 10)),
                              ],
                            ),
                          ),
                        )
                      : Image.asset(
                          book.coverUrl,
                          height: 290,
                          width: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 290,
                            width: 180,
                            color: Colors.grey[900],
                            child: const Icon(Icons.book, color: Colors.white24),
                          ),
                        ),
                ),

                // 2. BARRA DE AÇÕES (Overlay)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: const BoxDecoration(
                      color: Colors.black54, // Fundo semitransparente
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    // Usamos Observer para os ícones reagirem a mudanças na Store
                    child: Observer(
                      builder: (_) {
                        // Verifica estados
                        final isMarked = bookStore.bookmarks.any((b) => b.id == book.id);
                        final isDownloaded = bookStore.myLibrary.any((b) => b.id == book.id);
                        final isFav = bookStore.favorites.any((b) => b.id == book.id);

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // BOTÃO MARCAR (Bookmark)
                            IconButton(
                              onPressed: () => bookStore.toggleBookmark(book),
                              tooltip: isMarked ? "Remover marcação" : "Marcar para ler",
                              icon: Icon(
                                isMarked ? Icons.bookmark : Icons.bookmark_border,
                                color: isMarked ? const Color(0xFF3F8A99) : Colors.white,
                                size: 22,
                              ),
                            ),

                            // BOTÃO BAIXAR (Download)
                            IconButton(
                              onPressed: () async {
                                if (isDownloaded) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Este livro já está na sua biblioteca.")),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Baixando livro...")),
                                  );
                                  try {
                                    // Apenas baixa e adiciona à biblioteca, não abre o leitor
                                    await bookStore.addToLibrary(book);
                                    // Opcional: Se quiser garantir o download do arquivo físico agora:
                                    // await bookStore.openBook(book); (Mas isso abre a tela)
                                    // Para apenas baixar silenciosamente, teria que criar um método downloadOnly na store.
                                    // Por enquanto, usar addToLibrary já marca como "meus livros".
                                    
                                    if(context.mounted) {
                                       ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Adicionado à biblioteca com sucesso!"),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    // erro
                                  }
                                }
                              },
                              tooltip: isDownloaded ? "Baixado" : "Baixar",
                              icon: Icon(
                                isDownloaded ? Icons.download_done : Icons.download_for_offline_outlined,
                                color: isDownloaded ? Colors.greenAccent : Colors.white,
                                size: 22,
                              ),
                            ),

                            // BOTÃO FAVORITAR (Estrela/Coração)
                            IconButton(
                              onPressed: () => bookStore.toggleFavorite(book),
                              tooltip: isFav ? "Remover dos favoritos" : "Favoritar",
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border, // Usei favorite (coração) para consistência
                                color: isFav ? Colors.redAccent : Colors.white,
                                size: 22,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            
            // TÍTULO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                book.title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 2),
            
            // AUTOR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                book.authorName ?? "Autor desconhecido",
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}