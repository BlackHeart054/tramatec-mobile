// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:tramatec_app/config/service_locator.dart';
import 'package:tramatec_app/stores/write_store.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final WriteStore writeStore = getIt<WriteStore>();

  @override
  void deactivate() {
    writeStore.saveNow();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C101C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C101C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            writeStore.saveNow();
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Editor',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Observer(
              builder: (_) => Center(
                child: Text(
                  writeStore.saveStatus,
                  style: TextStyle(
                    color: writeStore.saveStatus.contains("Erro")
                        ? Colors.redAccent
                        : Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.save_outlined, color: Colors.white),
            tooltip: "Salvar Agora",
            onPressed: () => writeStore.saveNow(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF131A2C),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                  )
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: writeStore.titleController,
                onChanged: (_) => writeStore.onTextChanged(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                decoration: InputDecoration(
                  hintText: "Título da Obra",
                  hintStyle: TextStyle(
                    color: Colors.white24,
                    fontSize: 26,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF131A2C),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 4),
                      blurRadius: 8,
                    )
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: writeStore.contentController,
                  onChanged: (_) => writeStore.onTextChanged(),
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  textAlignVertical: TextAlignVertical.top,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.6,
                  ),
                  decoration: const InputDecoration(
                    hintText: "Era uma vez...",
                    hintStyle: TextStyle(color: Colors.white24, fontSize: 16),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
