import 'dart:io';
import 'package:flutter/material.dart';
import 'package:epub_view/epub_view.dart';

class EpubReaderPage extends StatefulWidget {
  final String epubPath;
  final String bookId;

  const EpubReaderPage({
    super.key,
    required this.epubPath,
    required this.bookId,
  });

  @override
  State<EpubReaderPage> createState() => _EpubReaderPageState();
}

class _EpubReaderPageState extends State<EpubReaderPage> {
  late EpubController _epubController;

  // Chave para controlar a abertura do Drawer manualmente
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initEpub();
  }

  Future<void> _initEpub() async {
    final file = File(widget.epubPath);

    if (!file.existsSync()) {
      if (mounted) Navigator.pop(context);
      return;
    }

    _epubController = EpubController(
      document: EpubDocument.openFile(file),
      // Você pode adicionar epubCfi aqui se quiser salvar o progresso
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _epubController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0C101C),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      key: _scaffoldKey, // <--- Importante: Atribuímos a chave aqui
      backgroundColor: const Color(0xFF0C101C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C101C),
        title: EpubViewActualChapter(
          controller: _epubController,
          builder: (chapterValue) => Text(
            // CORREÇÃO 1: 'title' em minúsculo
            chapterValue?.chapter?.Title?.replaceAll('\n', '').trim() ??
                'Leitura',
            style: const TextStyle(color: Colors.white, fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.format_list_bulleted, color: Colors.white),
            // CORREÇÃO 2: Usamos a chave para abrir o drawer
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
        ],
      ),
      // Usamos endDrawer para abrir no lado direito (padrão de livros)
      // Se preferir na esquerda, mude para 'drawer' e ajuste o onPressed acima para openDrawer()
      endDrawer: Drawer(
        backgroundColor: const Color(0xFF191D3A),
        child: EpubViewTableOfContents(
          controller: _epubController,
          itemBuilder: (context, index, chapter, itemCount) {
            return ListTile(
              // CORREÇÃO 3: 'title' em minúsculo
              title: Text(chapter.title?.trim() ?? "Capítulo ${index + 1}",
                  style: const TextStyle(color: Colors.white)),
              onTap: () {
                // CORREÇÃO 4: 'startIndex' em minúsculo e uso do método correto jumpTo
                _epubController.jumpTo(index: chapter.startIndex);
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
      body: EpubView(
        builders: EpubViewBuilders<DefaultBuilderOptions>(
          options: const DefaultBuilderOptions(
            textStyle: TextStyle(
              height: 1.5,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          loaderBuilder: (_) => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
        controller: _epubController,
      ),
    );
  }
}
