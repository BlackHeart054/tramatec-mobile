import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:tramatec_app/screens/login_screen.dart';
import 'package:tramatec_app/screens/registration_screen.dart';
import 'package:tramatec_app/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tramatec',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0C101C),
      ),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(
              userName: "Lucas Menezes",
              avatarUrl: null,
              isFirstAccess: false,
            ),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        // TODO: Adicionar a rota para a home screen após o login
        // '/home': (context) => const HomeScreen(),
      },
    );
  }
}
