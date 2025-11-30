import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tramatec_app/custom_widgets/custom_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isFetching = true;

  final _nomeController = TextEditingController();
  final _sobrenomeController = TextEditingController();
  final _dddController = TextEditingController();
  final _phoneController = TextEditingController();

  File? _imageFile;
  String? _currentPhotoUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          final data = doc.data()!;
          _nomeController.text = data['firstName'] ?? '';
          _sobrenomeController.text = data['lastName'] ?? '';
          _dddController.text = data['ddd'] ?? '';
          _phoneController.text = data['phoneNumber'] ?? '';
        }
        _currentPhotoUrl = user.photoURL;
      } catch (e) {
        print("Erro ao carregar dados: $e");
      }
    }
    if (mounted) setState(() => _isFetching = false);
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      String? photoUrl = _currentPhotoUrl;

      // 1. Upload da Imagem (se houver nova)
      if (_imageFile != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_avatars')
            .child('${user.uid}.jpg');

        await ref.putFile(_imageFile!);
        photoUrl = await ref.getDownloadURL();
      }

      // 2. Atualizar Auth (Profile básico)
      await user.updateDisplayName(
          "${_nomeController.text.trim()} ${_sobrenomeController.text.trim()}");

      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      // 3. Atualizar Firestore (Dados detalhados)
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'firstName': _nomeController.text.trim(),
        'lastName': _sobrenomeController.text.trim(),
        'ddd': _dddController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        if (photoUrl != null)
          'photoUrl': photoUrl, // Opcional salvar no doc também
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Perfil atualizado com sucesso!')));
        Navigator.pop(context); // Volta para Settings
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(backgroundColor: Colors.red, content: Text('Erro: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isFetching) {
      return const Scaffold(
          backgroundColor: Color(0xFF0C101C),
          body: Center(child: CircularProgressIndicator(color: Colors.white)));
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0C101C),
      appBar: AppBar(
        title:
            const Text('Editar Perfil', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0C101C),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Foto de Perfil
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[800],
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!) as ImageProvider
                          : (_currentPhotoUrl != null
                              ? NetworkImage(_currentPhotoUrl!)
                              : null),
                      child: (_imageFile == null && _currentPhotoUrl == null)
                          ? const Icon(Icons.person,
                              size: 60, color: Colors.white)
                          : null,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF3F8A99),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt,
                          size: 20, color: Colors.white),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'NOME',
                      controller: _nomeController,
                      validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      label: 'SOBRENOME',
                      controller: _sobrenomeController,
                      validator: (v) => v!.isEmpty ? 'Obrigatório' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomTextField(
                      label: 'DDD',
                      controller: _dddController,
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 5,
                    child: CustomTextField(
                      label: 'TELEFONE',
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      maxLength: 9,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F8A99)),
                  onPressed: _isLoading ? null : _saveProfile,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('SALVAR ALTERAÇÕES',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
