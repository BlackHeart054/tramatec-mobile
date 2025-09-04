import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tramatec_app/custom_widgets/custom_textfield.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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

  double _scaleForWidth(double screenWidth) {
    return (screenWidth / 375.0).clamp(0.85, 1.15);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double scale = _scaleForWidth(size.width);
    bool isLoading = false;

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

    Future<void> registerUser() async {
      if (_senhaController.text != _confirmarSenhaController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("As senhas não coincidem.")),
        );
        return;
      }

      setState(() {
        isLoading = true;
      });

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _senhaController.text,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Cadastro realizado com sucesso!")),
          );
          Navigator.pushReplacementNamed(context, '/login');
        }
      } on FirebaseAuthException catch (e) {
        if (kDebugMode) {
          print("Erro no cadastro: ${e.message}");
        }
        String errorMessage = "Ocorreu um erro ao cadastrar.";
        if (e.code == 'weak-password') {
          errorMessage = 'A senha fornecida é muito fraca.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'Já existe uma conta com este email.';
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0C101C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'VAMOS DAR INÍCIO A\nNOSSA AVENTURA?',
          textAlign: TextAlign.center,
          style: titleStyle,
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (size.width * 0.06).clamp(12.0, 32.0),
                  vertical: (size.height * 0.015).clamp(8.0, 24.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  label: 'NOME',
                                  controller: _nomeController,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextField(
                                  label: 'SOBRENOME',
                                  controller: _sobrenomeController,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.015),

                          CustomTextField(
                            label: 'EMAIL',
                            controller: _emailController,
                          ),
                          SizedBox(height: size.height * 0.015),

                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: CustomTextField(
                                  label: 'DDD',
                                  controller: _dddController,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 5,
                                child: CustomTextField(
                                  label: 'TELEFONE',
                                  controller: _telefoneController,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.015),

                          CustomTextField(
                            label: 'SENHA',
                            controller: _senhaController,
                            isPassword: true,
                          ),
                          SizedBox(height: size.height * 0.015),

                          CustomTextField(
                            label: 'CONFIRMAR SENHA',
                            controller: _confirmarSenhaController,
                            isPassword: true,
                          ),
                        ],
                      ),
                    ),

                    Column(
                      children: [
                        SizedBox(
                          height: (size.height * 0.065).clamp(44.0, 54.0),
                          width: double.infinity,
                          child: ElevatedButton(
                           onPressed: isLoading ? null : registerUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3F8A99),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text(
                                    'CADASTRAR',
                              style: TextStyle(
                                fontSize: 16,
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
                            Text('JÁ POSSUI UMA CONTA? ', style: linkBaseStyle),
                            TextButton(
                              onPressed: () {
                               Navigator.pushReplacementNamed(
                                    context, '/login');
                              },
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
