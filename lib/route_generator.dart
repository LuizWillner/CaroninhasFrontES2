import 'package:app_uff_caronas/pages/login.dart';
import 'package:app_uff_caronas/pages/cadastro.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: ((context) => const Login()));
      case '/cadastro':
        return MaterialPageRoute(builder: ((context) => const Cadastro()));
      default:
        return MaterialPageRoute(builder: ((context) => const Login()));
    }
  }
}
