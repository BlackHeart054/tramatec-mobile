import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tramatec_app/custom_widgets/book_carousel.dart';
import 'package:tramatec_app/main.dart';
import 'package:tramatec_app/stores/book_store.dart';
import 'package:tramatec_app/models/carousel_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final BookStore bookStore;

  @override
  void initState() {
    super.initState();
    bookStore = getIt<BookStore>();
    // dispara a busca dos dados
    bookStore.fetchHomeScreenData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C101C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C101C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.person_search_outlined, color: Colors.white),
          onPressed: () {},
        ),
        title: _buildSearchBar(),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              // TODO: abrir filtros
            },
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (bookStore.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (bookStore.carousels.isEmpty) {
            return const Center(
              child: Text("Nenhum conteúdo disponível",
                  style: TextStyle(color: Colors.white)),
            );
          }

          return ListView.builder(
            itemCount: bookStore.carousels.length,
            itemBuilder: (context, index) {
              final Carousel carousel = bookStore.carousels[index];
              return BookCarousel(title: carousel.title, books: carousel.books);
            },
          );
        },
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        // TODO: criar busca
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF222B45),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: const [
            Icon(Icons.search, color: Colors.grey, size: 20),
            SizedBox(width: 8),
            Text(
              'Pesquisar livros...',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 0,
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF0C101C),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey.shade600,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined), label: 'Início'),
        BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined), label: 'Explorar'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: 'Perfil'),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined), label: 'Ajustes'),
      ],
    );
  }
}
