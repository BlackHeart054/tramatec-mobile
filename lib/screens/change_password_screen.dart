import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tramatec_app/custom_widgets/custom_textfield.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('As novas senhas não coincidem.')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      final email = user?.email;

      if (user != null && email != null) {
        final credential = EmailAuthProvider.credential(
            email: email, password: _currentPasswordController.text);

        await user.reauthenticateWithCredential(credential);

        await user.updatePassword(_newPasswordController.text);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Senha alterada com sucesso!')));
          Navigator.pop(context);
        }
      }
    } on FirebaseAuthException catch (e) {
      String msg = 'Erro ao alterar senha.';
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        msg = 'Senha atual incorreta.';
      } else if (e.code == 'weak-password') {
        msg = 'A nova senha é muito fraca.';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(backgroundColor: Colors.red, content: Text(msg)));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C101C),
      appBar: AppBar(
        title:
            const Text('Alterar Senha', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0C101C),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                label: 'SENHA ATUAL',
                controller: _currentPasswordController,
                isPassword: true,
                validator: (val) =>
                    val!.isEmpty ? 'Digite sua senha atual' : null,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'NOVA SENHA',
                controller: _newPasswordController,
                isPassword: true,
                validator: (val) =>
                    val!.length < 6 ? 'Mínimo de 6 caracteres' : null,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'CONFIRMAR NOVA SENHA',
                controller: _confirmPasswordController,
                isPassword: true,
                validator: (val) =>
                    val!.isEmpty ? 'Confirme a nova senha' : null,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F8A99)),
                  onPressed: _isLoading ? null : _changePassword,
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
