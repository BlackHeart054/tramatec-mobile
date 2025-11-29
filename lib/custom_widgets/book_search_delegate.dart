import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tramatec_app/config/service_locator.dart';
import 'package:tramatec_app/stores/book_store.dart';
import 'package:tramatec_app/screens/explore_screen.dart';

class BookSearchDelegate extends SearchDelegate {
  final BookStore bookStore = getIt<BookStore>();

  BookSortOption currentSort = BookSortOption.relevance;

  @override
  String? get searchFieldLabel => 'Pesquisar título, autor...';

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0C101C),
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white54),
        border: InputBorder.none,
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Color(0xFF3F8A99),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear, color: Colors.white),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
      PopupMenuButton<BookSortOption>(
        icon: const Icon(Icons.sort, color: Colors.white),
        tooltip: "Ordenar resultados",
        onSelected: (BookSortOption result) {
          currentSort = result;
          if (query.isNotEmpty) {
            bookStore.searchBooks(query, sort: currentSort);
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<BookSortOption>>[
          const PopupMenuItem(
              value: BookSortOption.relevance, child: Text('Relevância')),
          const PopupMenuItem(
              value: BookSortOption.alphabeticalAZ, child: Text('A-Z')),
          const PopupMenuItem(
              value: BookSortOption.alphabeticalZA, child: Text('Z-A')),
          const PopupMenuItem(
              value: BookSortOption.newest, child: Text('Mais Recentes')),
        ],
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        bookStore.clearSearch();
        close(context, null);
      },
    );
  }

  Widget _buildSearchResults() {
    if (query.isNotEmpty) {
      bookStore.searchBooksDebounced(query);
    } else {
      bookStore.clearSearch();
    }

    return Container(
      color: const Color(0xFF0C101C),
      child: Observer(
        builder: (_) {
          if (bookStore.isSearching) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          }

          if (query.isEmpty) {
            return Container();
          }

          if (bookStore.searchResults.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 60, color: Colors.white24),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum livro encontrado para "$query"',
                    style: const TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: bookStore.searchResults.length,
            itemBuilder: (context, index) {
              final book = bookStore.searchResults[index];
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: book.coverUrl.startsWith('http')
                      ? Image.network(book.coverUrl,
                          width: 40, height: 60, fit: BoxFit.cover)
                      : Image.asset(book.coverUrl,
                          width: 40,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(width: 40, color: Colors.grey)),
                ),
                title: Text(book.title,
                    style: const TextStyle(color: Colors.white)),
                subtitle: Text(book.authorName ?? "Autor desconhecido",
                    style: const TextStyle(color: Colors.white54)),
                onTap: () {
                  // Fecha o teclado para melhor UX
                  FocusScope.of(context).unfocus();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => BookPreviewSheet(book: book),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }
}
