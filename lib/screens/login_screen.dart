import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tramatec_app/custom_widgets/custom_textfield.dart';
import 'package:tramatec_app/custom_widgets/error_message.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _hasError = false;
  bool _isLoading = false;
  String? _errorMessage;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _validateAndLogin() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Por favor, preencha todos os campos.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Ocorreu um erro ao fazer login.";
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        errorMessage = 'Email ou senha inválidos.';
      }

      setState(() {
        _hasError = true;
        _errorMessage = errorMessage;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  double _scaleForWidth(double screenWidth) {
    final double factor = (screenWidth / 375.0).clamp(0.85, 1.25);
    return factor;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double scale = _scaleForWidth(size.width);

    final double hPadding = (size.width * 0.08).clamp(16.0, 40.0);
    final double vPadding = (size.height * 0.05).clamp(16.0, 48.0);

    final TextStyle titleStyle1 = TextStyle(
      color: Colors.white,
      fontSize: (28.0 * scale).clamp(22.0, 32.0),
      fontWeight: FontWeight.w300,
    );

    final TextStyle titleStyle2 = TextStyle(
      color: Colors.white,
      fontSize: (36.0 * scale).clamp(28.0, 40.0),
      fontWeight: FontWeight.bold,
    );

    final TextStyle linkBaseStyle = TextStyle(
      color: Colors.white70,
      fontSize: (13.0 * scale).clamp(12.0, 15.0),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0C101C),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final Widget content = ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'BOAS VINDAS A',
                    textAlign: TextAlign.center,
                    style: titleStyle1,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'TRAMATEC!',
                    textAlign: TextAlign.center,
                    style: titleStyle2,
                  ),

                  SizedBox(height: (size.height * 0.05).clamp(16.0, 48.0)),

                  if (_errorMessage != null) ...[
                    ErrorMessage(message: _errorMessage!),
                    SizedBox(height: (size.height * 0.02).clamp(8.0, 20.0)),
                  ],

                  CustomTextField(
                    label: 'EMAIL',
                    controller: _emailController,
                    hasError: _hasError,
                  ),
                  SizedBox(height: (size.height * 0.025).clamp(12.0, 24.0)),
                  CustomTextField(
                    label: 'SENHA',
                    controller: _passwordController,
                    isPassword: true,
                  ),

                  SizedBox(height: (size.height * 0.015).clamp(8.0, 16.0)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: recuperação de senha
                      },
                      child: Text(
                        'ESQUECI A SENHA',
                        style: linkBaseStyle,
                      ),
                    ),
                  ),

                  SizedBox(height: (size.height * 0.03).clamp(16.0, 28.0)),
                  SizedBox(
                    height: (size.height * 0.07).clamp(44.0, 56.0),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _validateAndLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53935),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'ENTRAR',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: (size.height * 0.03).clamp(16.0, 32.0)),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('NÃO POSSUI UMA CONTA? ', style: linkBaseStyle),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');

                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'CRIE AQUI',
                          style: linkBaseStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: (size.height * 0.05).clamp(20.0, 48.0)),
                  Center(
                    child: Image.asset(
                      'assets/images/tramatec_logo.png',
                      height: (size.height * 0.08).clamp(40.0, 80.0),
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            );

            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: hPadding,
                  vertical: vPadding,
                ),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: content,
              ),
            );
          },
        ),
      ),
    );
  }
}
