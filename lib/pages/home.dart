import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/home_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * (0.6),
            ),
            Container(
              height: MediaQuery.of(context).size.height * (0.4),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "Viagens com preços baixos para você",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF0E4B7C),
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.all(2),
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                width: 1.0,
                                color: Color(0xFF00AFF8),
                                style: BorderStyle.solid,
                              ),
                              backgroundColor: const Color(0xFF00AFF8),
                            ),
                            onPressed: (() {
                              Navigator.of(context).pushNamed(
                                '/Login',
                              );
                            }),
                            child: const Text(
                              'Entrar',
                              style: TextStyle(
                                  color: Color(0xFFFAFAFA), fontSize: 24),
                            ))),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.all(2),
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                width: 1.0,
                                color: Color(0xFFFAFAFA),
                                style: BorderStyle.solid,
                              ),
                              backgroundColor: const Color(0xFFFAFAFA),
                            ),
                            onPressed: (() {
                              Navigator.of(context).pushNamed(
                                '/Cadastro',
                              );
                            }),
                            child: const Text(
                              'Cadastre-se',
                              style: TextStyle(
                                  color: Color(0xFF00AFF8), fontSize: 24),
                            ))),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
