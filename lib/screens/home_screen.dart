import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tramatec_app/custom_widgets/book_carousel.dart';
import 'package:tramatec_app/main.dart';
import 'package:tramatec_app/stores/book_store.dart';
import 'package:tramatec_app/models/carousel_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../config/service_locator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final BookStore bookStore;
  int selectedIndex = 0;
  String _appVersion = '';
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    bookStore = getIt<BookStore>();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final user = FirebaseAuth.instance.currentUser;
    if (mounted) {
      setState(() {
        _appVersion = 'v${packageInfo.version}';
        _currentUser = user;
      });
    }
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
      drawer: _buildAppDrawer(),
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
            child: Image.asset(
              'assets/images/tramatec_logo.png',
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
            ),
          AboutListTile(
            icon: const Icon(Icons.info_outline, color: Colors.white70),
            applicationIcon: Image.asset(
              'assets/images/white_logo.png',
              height: 80,
            ),
            applicationName: 'Tramatec',
            applicationVersion: _appVersion,
            applicationLegalese: '© 2025 Tramatec',
            aboutBoxChildren: const [
              SizedBox(height: 16),
              Text('Objetivo do Aplicativo:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Este aplicativo tem como objetivo fornecer uma plataforma '
                  'rica e imersiva para a criação, descoberta e leitura de novos livros, '
                  'contos e crônicas.'),
              SizedBox(height: 24),
              Text('Equipe de Desenvolvimento:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• Lucas Menezes\n'),
            ],
            child: const Text(
              'Sobre o App',
              style: TextStyle(color: Colors.white70),
            ),
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
        child: const Row(
          children: [
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
      currentIndex: selectedIndex,
      onTap: (index) {
        setState(() => selectedIndex = index);
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
            icon: Icon(Icons.person_outline), label: 'Perfil'),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined), label: 'Ajustes'),
      ],
    );
  }
}
