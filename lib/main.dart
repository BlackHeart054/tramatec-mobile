import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tramatec_app/config/app_routes.dart';
import 'package:tramatec_app/config/app_theme.dart';
import 'package:tramatec_app/config/service_locator.dart';
import 'firebase_options.dart';
import 'package:tramatec_app/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Tramatec',
      theme: AppTheme.darkTheme,
      home: const AuthWrapper(),
      routes: AppRoutes.routes,
    );
  }
}
