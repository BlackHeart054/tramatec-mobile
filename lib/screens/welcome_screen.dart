import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  final String userName;
  final String? avatarUrl;
  final bool isFirstAccess;

  const WelcomeScreen({
    super.key,
    required this.userName,
    this.avatarUrl,
    this.isFirstAccess = false,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _loading = false;
        });

        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final message = widget.isFirstAccess
        ? "BEM-VINDO À SUA PRIMEIRA VEZ NA TRAMATEC!"
        : "QUE BOM TE VER NOVAMENTE!";

    return Scaffold(
      backgroundColor: const Color(0xFF0C101C),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: constraints.maxWidth * 0.07,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                    CircleAvatar(
                      radius: constraints.maxWidth * 0.18,
                      backgroundColor: Colors.grey.shade800,
                      backgroundImage: widget.avatarUrl != null
                          ? AssetImage(widget.avatarUrl!)
                          : const AssetImage(
                              'assets/images/default_avatar.png'),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.userName,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: constraints.maxWidth * 0.05,
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (_loading) ...[
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Carregando informações, aguarde...",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                    const Spacer(),
                    Image.asset(
                      'assets/images/tramatec_logo.png',
                      height: constraints.maxHeight * 0.08,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
