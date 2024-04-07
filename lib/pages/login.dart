import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
      title: const Text('CovidT'),
      backgroundColor: const Color.fromARGB(255, 70, 70, 70)
        ),
      body: Center(
        child: Column(children: [
    Container(
      width: 400,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(2),
      child: OutlinedButton(
      onPressed: (() {
        Navigator.of(context).pushNamed(
          '/cadastro',
        );
      }),
      child: const Text('Clique aqui para se cadastrar')
      ),
    )  
      ])),
        );
  }
}