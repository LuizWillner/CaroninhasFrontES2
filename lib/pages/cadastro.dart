import 'package:flutter/material.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
      title: const Text('Cadastro'),
      backgroundColor: const Color.fromARGB(255, 70, 70, 70)
        ),
      body: Center(
        child: Column(children: [
        Container(
          width: 200,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(2),
          child: OutlinedButton(
          onPressed: (() {
              Navigator.of(context).pushNamed(
                '/Login',
              );
            }),
           child: const Text('Cadastro')
           ),
      )
      ])),
        );
  }
}