import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'write_store.g.dart';

// ignore: library_private_types_in_public_api
class WriteStore = _WriteStore with _$WriteStore;

abstract class _WriteStore with Store {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Timer? _saveTimer;

  @observable
  ObservableList<Map<String, dynamic>> drafts =
      ObservableList<Map<String, dynamic>>();

  @observable
  bool isLoading = false;

  @observable
  String saveStatus = "Salvo";

  String? currentDraftId;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @action
  Future<void> fetchDrafts() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    isLoading = true;
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('drafts')
          .orderBy('updatedAt', descending: true)
          .get();

      final list = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      drafts = ObservableList.of(list);
    } catch (e) {
      if (kDebugMode) print("Erro ao buscar rascunhos: $e");
    } finally {
      isLoading = false;
    }
  }

  @action
  void openDraft(Map<String, dynamic>? draft) {
    if (draft == null) {
      currentDraftId = null;
      titleController.text = "";
      contentController.text = "";
      saveStatus = "Novo Rascunho";
    } else {
      currentDraftId = draft['id'];
      titleController.text = draft['title'] ?? "";
      contentController.text = draft['content'] ?? "";
      saveStatus = "Salvo";
    }
  }

  @action
  void onTextChanged() {
    saveStatus = "Escrevendo...";

    if (_saveTimer?.isActive ?? false) _saveTimer!.cancel();

    _saveTimer = Timer(const Duration(seconds: 2), () {
      saveNow();
    });
  }

  @action
  Future<void> saveNow() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (titleController.text.isEmpty && contentController.text.isEmpty) return;

    saveStatus = "Salvando...";

    try {
      final data = {
        'title': titleController.text,
        'content': contentController.text,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (currentDraftId == null) {
        final ref = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('drafts')
            .add({...data, 'createdAt': FieldValue.serverTimestamp()});
        currentDraftId = ref.id;

        drafts.insert(0, {...data, 'id': currentDraftId});
      } else {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('drafts')
            .doc(currentDraftId)
            .update(data);

        final index = drafts.indexWhere((d) => d['id'] == currentDraftId);
        if (index != -1) {
          drafts[index] = {...drafts[index], ...data};
        }
      }

      runInAction(() => saveStatus = "Salvo com sucesso");
    } catch (e) {
      if (kDebugMode) print("Erro ao salvar: $e");
      runInAction(() => saveStatus = "Erro ao salvar!");
    }
  }
}
