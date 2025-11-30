import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tramatec_app/config/service_locator.dart';
import 'package:tramatec_app/screens/editor_screen.dart';
import 'package:tramatec_app/stores/write_store.dart';

class CreateDashboardScreen extends StatefulWidget {
  const CreateDashboardScreen({super.key});

  @override
  State<CreateDashboardScreen> createState() => _CreateDashboardScreenState();
}

class _CreateDashboardScreenState extends State<CreateDashboardScreen> {
  final WriteStore writeStore = getIt<WriteStore>();

  @override
  void initState() {
    super.initState();
    writeStore.fetchDrafts();
  }

  void _openEditor(Map<String, dynamic>? draft) {
    writeStore.openDraft(draft);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditorScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C101C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C101C),
        elevation: 0,
        title: const Text(
          'Meus Rascunhos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF3F8A99),
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text(
          "Novo Livro",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        onPressed: () => _openEditor(null),
      ),
      body: Observer(
        builder: (_) {
          if (writeStore.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (writeStore.drafts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.history_edu,
                      size: 60, color: Colors.white24),
                  const SizedBox(height: 16),
                  const Text(
                    'Você ainda não escreveu nada.',
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F8A99),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    onPressed: () => _openEditor(null),
                    child: const Text(
                      "Começar a escrever",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: writeStore.drafts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final draft = writeStore.drafts[index];
              final String title = draft['title']?.toString().isEmpty ?? true
                  ? "Sem Título"
                  : draft['title'];

              final String content =
                  (draft['content'] ?? "").toString().replaceAll('\n', ' ');

              return GestureDetector(
                onTap: () => _openEditor(draft),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: const Color(0xFF191D3A),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.25),
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                      )
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    title: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.white24,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
