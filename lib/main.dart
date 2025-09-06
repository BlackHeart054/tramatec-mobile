import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:tramatec_app/screens/home_screen.dart';
import 'package:tramatec_app/stores/book_store.dart';
import 'firebase_options.dart';

import 'package:tramatec_app/screens/login_screen.dart';
import 'package:tramatec_app/screens/registration_screen.dart';
import 'package:tramatec_app/screens/welcome_screen.dart';

GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  getIt.registerSingletonAsync<BookStore>(() async {
    final bookStore = BookStore();
    return bookStore;
  });
  await getIt.allReady();
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
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
