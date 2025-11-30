import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tramatec_app/custom_widgets/book_search_delegate.dart';
import 'package:tramatec_app/custom_widgets/custom_drawer.dart';
import 'package:tramatec_app/screens/create_dashboard_screen.dart';
import 'package:tramatec_app/screens/settings_screen.dart';
import 'package:tramatec_app/stores/book_store.dart';

import '../config/service_locator.dart';
import 'explore_screen.dart';
import 'initial_page_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final BookStore bookStore;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    bookStore = getIt<BookStore>();
    if (bookStore.carousels.isEmpty) {
      bookStore.fetchHomeScreenData();
    }
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF191D3A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Ordenar Livros (Aba Explorar)",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(color: Colors.white24),
              _buildSortOptionTile(
                  "Padrão (Relevância)", BookSortOption.relevance),
              _buildSortOptionTile("A - Z", BookSortOption.alphabeticalAZ),
              _buildSortOptionTile("Z - A", BookSortOption.alphabeticalZA),
              _buildSortOptionTile("Mais Recentes", BookSortOption.newest),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOptionTile(String title, BookSortOption option) {
    return Observer(
      builder: (_) {
        final isSelected = bookStore.currentExploreSort == option;
        return ListTile(
          title: Text(
            title,
            style: TextStyle(
              color: isSelected ? const Color(0xFF3F8A99) : Colors.white70,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          trailing: isSelected
              ? const Icon(Icons.check, color: Color(0xFF3F8A99))
              : null,
          onTap: () {
            bookStore.setExploreSort(option);

            Navigator.pop(context);

            if (_selectedIndex == 0) {
              setState(() {
                _selectedIndex = 1;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Indo para Explorar para ver a ordenação."),
                  duration: Duration(seconds: 1),
                ),
              );
            }
          },
        );
      },
    );
  }

  AppBar _buildInitialAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0C101C),
      elevation: 0,
      title: _buildSearchBar(),
      actions: [
        if (_selectedIndex == 1)
          IconButton(
            icon: const Icon(Icons.sort, color: Colors.white),
            tooltip: "Ordenar",
            onPressed: _showSortOptions,
          ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        showSearch(
          context: context,
          delegate: BookSearchDelegate(),
        );
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

  final List<Widget> _screens = [
    const InitialPageContent(),
    const ExploreScreen(),
    const CreateDashboardScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C101C),
      appBar: [0, 1].contains(_selectedIndex) ? _buildInitialAppBar() : null,
      body: _screens[_selectedIndex],
      bottomNavigationBar: _buildBottomNav(),
      drawer: const CustomDrawer(),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() => _selectedIndex = index);
      },
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
            icon: Icon(Icons.new_label_outlined), label: 'Criar'),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined), label: 'Ajustes'),
      ],
    );
  }
}
