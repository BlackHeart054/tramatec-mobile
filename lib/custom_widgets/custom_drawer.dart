import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tramatec_app/config/service_locator.dart';
import 'package:tramatec_app/custom_widgets/background_template.dart';
import 'package:tramatec_app/custom_widgets/epub_reader.dart';
import 'package:tramatec_app/screens/library_screen.dart';
import 'package:tramatec_app/screens/login_screen.dart';
import 'package:tramatec_app/screens/section_books_screen.dart';
import 'package:tramatec_app/stores/book_store.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  Future<void> _logout(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sair', style: TextStyle(color: Colors.white)),
          content: const Text('Deseja realmente sair do Tramatec?',
              style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            LoginScreen.route, (Route<dynamic> route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    final Color backgroundColor = const Color(0xFF131A2C);
    final Color cardColor = const Color(0xFF131A2C);
    final Color textColor = Colors.white;
    final Color textSecondaryColor = Colors.white70;
    final Color iconColor = const Color(0xFF3F8A99);

    return Drawer(
      backgroundColor: backgroundColor,
      child: BackgroundTemplate(
        showLogo: true,
        showVersion: true,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Divider(color: Colors.white24, height: 30),
                    if (user != null) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: cardColor,
                          backgroundImage: user.photoURL != null
                              ? NetworkImage(user.photoURL!)
                              : null,
                          child: user.photoURL == null
                              ? Text(
                                  user.email?[0].toUpperCase() ?? 'U',
                                  style: const TextStyle(
                                      fontSize: 24, color: Colors.white),
                                )
                              : null,
                        ),
                      ),
                      Text(
                        user.displayName ?? 'Usuário Tramatec',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        user.email ?? '',
                        style:
                            TextStyle(color: textSecondaryColor, fontSize: 12),
                      ),
                      const SizedBox(height: 20),
                    ],
                    _DrawerButtonCard(
                      cardColor: cardColor,
                      label: 'Continuar Lendo',
                      icon: Icons.play_circle_outline,
                      iconColor: iconColor,
                      textColor: textColor,
                      onPressed: () async {
                        Navigator.pop(context);
                        final store = getIt<BookStore>();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Carregando sua leitura...")));

                        try {
                          final path = await store.resumeReading();
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EpubReaderPage(
                                      epubPath: path,
                                      bookId: store.lastReadBookId!)));
                        } catch (e) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(e.toString()),
                                backgroundColor: Colors.orange),
                          );
                        }
                      },
                    ),
                    _DrawerButtonCard(
                      cardColor: cardColor,
                      label: 'Minha Biblioteca',
                      icon: Icons.collections_bookmark_outlined,
                      iconColor: iconColor,
                      textColor: textColor,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LibraryScreen()));
                      },
                    ),
                    _DrawerButtonCard(
                      cardColor: cardColor,
                      label: 'Favoritos',
                      icon: Icons.favorite_border,
                      iconColor: Colors.redAccent,
                      textColor: textColor,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SectionBooksScreen(
                              title: 'Favoritos',
                              sectionType: BookSectionType.favorites,
                            ),
                          ),
                        );
                      },
                    ),
                    _DrawerButtonCard(
                      cardColor: cardColor,
                      label: 'Marcações',
                      icon: Icons.bookmark_border,
                      iconColor: iconColor,
                      textColor: textColor,
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SectionBooksScreen(
                              title: 'Livros Marcados',
                              sectionType: BookSectionType.bookmarks,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: _DrawerButtonCard(
                // ignore: deprecated_member_use
                cardColor: cardColor.withOpacity(0.5),
                label: 'Sair da Conta',
                icon: Icons.logout,
                iconColor: Colors.redAccent,
                textColor: Colors.redAccent,
                onPressed: () => _logout(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerButtonCard extends StatelessWidget {
  final Color cardColor;
  final String label;
  final IconData icon;
  final Color iconColor;
  final Color textColor;
  final VoidCallback? onPressed;

  const _DrawerButtonCard({
    required this.cardColor,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.textColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  size: 14,
                  // ignore: deprecated_member_use
                  color: textColor.withOpacity(0.3)),
            ],
          ),
        ),
      ),
    );
  }
}
