import 'package:flutter/material.dart';
import 'package:tramatec_app/screens/settings_screen.dart';
import 'package:tramatec_app/stores/book_store.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    bookStore = getIt<BookStore>();
    if (bookStore.carousels.isEmpty) {
      bookStore.fetchHomeScreenData();
    }
  }

  AppBar _buildInitialAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0C101C),
      elevation: 0,
      title: _buildSearchBar(),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.white),
          onPressed: () {},
        ),
      ],
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

  Widget _buildAppDrawer() {
    final photoUrl = _currentUser?.photoURL;
    return Drawer(
      backgroundColor: const Color(0xFF191D3A),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF0C101C),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Image.asset(
                'assets/images/tramatec_logo.png',
              ),
            ),
          ),
          if (_currentUser != null)
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white24,
                backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                    ? NetworkImage(photoUrl)
                    : null,
                child: (photoUrl == null || photoUrl.isEmpty)
                    ? Text(
                        _currentUser!.email![0].toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    : null,
              ),
              title: Text(
                _currentUser!.displayName ?? 'Usuário',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                _currentUser!.email!,
                style: const TextStyle(color: Colors.white70),
              ),
              onTap: () {
                setState(() => _selectedIndex = 2);
                Navigator.pop(context);
              },
            ),
          ListTile(
            leading:
                const Icon(Icons.play_circle_outline, color: Colors.white70),
            title: const Text(
              'Continuar Lendo',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // TODO: lógica para abrir o último livro que estava lendo
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_document, color: Colors.white70),
            title: const Text(
              'Continuar Escrevendo',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // TODO: lógica para abrir último livro que estava escrevendo
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.collections_bookmark_outlined,
                color: Colors.white70),
            title: const Text(
              'Minha Biblioteca',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // TODO: ir para tela da biblioteca
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.star_outline, color: Colors.white70),
            title: const Text(
              'Favoritos',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // TODO: ir para tela de favoritos
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white70),
            title: const Text(
              'Sair',
              style: TextStyle(color: Colors.white70),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
    );
  }

  final List<Widget> _screens = [
    const InitialPageContent(),
    const ExploreScreen(),
    const Center(child: Text('Criar', style: TextStyle(color: Colors.white))),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C101C),
      body: _screens[_selectedIndex],
      appBar: _selectedIndex == 0 ? _buildInitialAppBar() : null,
      bottomNavigationBar: _buildBottomNav(),
      drawer: _buildAppDrawer(),
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
