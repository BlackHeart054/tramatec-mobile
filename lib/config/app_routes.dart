import 'package:flutter/widgets.dart';
import 'package:tramatec_app/screens/home_screen.dart';
import 'package:tramatec_app/screens/login_screen.dart';
import 'package:tramatec_app/screens/registration_screen.dart';
import 'package:tramatec_app/screens/welcome_screen.dart';

class AppRoutes {
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static Map<String, WidgetBuilder> get routes {
    return {
      welcome: (context) => const WelcomeScreen(
            userName: "Lucas Menezes",
            isFirstAccess: false,
          ),
      login: (context) => const LoginScreen(),
      register: (context) => const RegistrationScreen(),
      home: (context) => const HomeScreen(),
    };
  }
}
