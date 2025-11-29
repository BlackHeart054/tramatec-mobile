import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tramatec_app/config/utils.dart';
import 'package:tramatec_app/custom_widgets/background_template.dart';
import 'package:tramatec_app/custom_widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _sobrenomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dddController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _sobrenomeController.dispose();
    _emailController.dispose();
    _dddController.dispose();
    _telefoneController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_senhaController.text != _confirmarSenhaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.orange,
            content: Text("As senhas não coincidem.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text,
      );

      User? user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(
            "${_nomeController.text.trim()} ${_sobrenomeController.text.trim()}");

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'firstName': _nomeController.text.trim(),
          'lastName': _sobrenomeController.text.trim(),
          'email': _emailController.text.trim(),
          'ddd': _dddController.text.trim(),
          'phoneNumber': _telefoneController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Cadastro realizado com sucesso!"),
          ),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print("Erro Auth: ${e.code}");
      }
      String errorMessage = "Ocorreu um erro ao cadastrar.";
      if (e.code == 'weak-password') {
        errorMessage = 'A senha fornecida é muito fraca.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'Já existe uma conta com este email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'O email fornecido é inválido.';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(errorMessage),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erro Geral: $e");
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Erro ao salvar dados do usuário."),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  double _scaleForWidth(double screenWidth) {
    return (screenWidth / 375.0).clamp(0.85, 1.15);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double scale = _scaleForWidth(size.width);

    final TextStyle titleStyle = TextStyle(
      color: Colors.white,
      fontSize: (22.0 * scale).clamp(18.0, 26.0),
      fontWeight: FontWeight.bold,
      height: 1.3,
    );

    final TextStyle linkBaseStyle = TextStyle(
      color: Colors.white70,
      fontSize: (12.0 * scale).clamp(11.0, 14.0),
    );

    return Scaffold(
      body: BackgroundTemplate(
        backgroundColor: const Color(0xFF0C101C),
        showLogo: false,
        showVersion: false,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: (size.width * 0.06).clamp(12.0, 32.0),
                  vertical: (size.height * 0.015).clamp(8.0, 24.0),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 40,
                    maxWidth: 520,
                  ),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'VAMOS DAR INÍCIO A\nNOSSA AVENTURA?',
                                textAlign: TextAlign.center,
                                style: titleStyle,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      label: 'NOME',
                                      controller: _nomeController,
                                      validator: (val) =>
                                          validateRequired(val, 'Nome'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: CustomTextField(
                                      label: 'SOBRENOME',
                                      controller: _sobrenomeController,
                                      validator: (val) =>
                                          validateRequired(val, 'Sobrenome'),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height * 0.015),
                              CustomTextField(
                                label: 'EMAIL',
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Email obrigatório';
                                  }
                                  if (!isValidEmail(val)) {
                                    return 'Email inválido';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: size.height * 0.015),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: CustomTextField(
                                      label: 'DDD',
                                      controller: _dddController,
                                      keyboardType: TextInputType.number,
                                      maxLength: 2,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      validator: (val) {
                                        if (val == null || val.length < 2) {
                                          return 'Inválido';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    flex: 5,
                                    child: CustomTextField(
                                      label: 'TELEFONE',
                                      controller: _telefoneController,
                                      keyboardType: TextInputType.number,
                                      maxLength: 9,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      validator: (val) =>
                                          validateRequired(val, 'Telefone'),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height * 0.015),
                              CustomTextField(
                                label: 'SENHA',
                                controller: _senhaController,
                                isPassword: true,
                                validator: validatePassword,
                              ),
                              SizedBox(height: size.height * 0.015),
                              CustomTextField(
                                label: 'CONFIRMAR SENHA',
                                controller: _confirmarSenhaController,
                                isPassword: true,
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Confirmação obrigatória';
                                  }
                                  if (val != _senhaController.text) {
                                    return 'Senhas não conferem';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(height: size.height * 0.03),
                              SizedBox(
                                height: (size.height * 0.065).clamp(44.0, 54.0),
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _registerUser,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF3F8A99),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : const Text(
                                          'CADASTRAR',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                              SizedBox(height: size.height * 0.015),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('JÁ POSSUI UMA CONTA? ',
                                      style: linkBaseStyle),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      'ENTRE AQUI',
                                      style: linkBaseStyle.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
