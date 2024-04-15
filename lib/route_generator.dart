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



class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Add login functionality here
              },
              child: Text('Login'),
            ),
            SizedBox(height: 10.0),
            TextButton(
              onPressed: () {
                // Add "Forgot your password?" functionality here
              },
              child: Text('Forgot your password?'),
            ),
          ],
        ),
      ),
    );
  }
}