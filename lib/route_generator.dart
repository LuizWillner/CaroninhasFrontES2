import 'package:app_uff_caronas/pages/home.dart';
import 'package:app_uff_caronas/pages/login.dart';
import 'package:app_uff_caronas/pages/cadastro.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/Home':
        return MaterialPageRoute(builder: ((context) => const Home()));
      case '/Login':
        return MaterialPageRoute(builder: ((context) => const Login()));
      case '/Cadastro':
        return MaterialPageRoute(builder: ((context) => const Cadastro()));
      default:
        return MaterialPageRoute(builder: ((context) => const Home()));
    }
  }
}


