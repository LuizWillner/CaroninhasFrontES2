import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * (4 / 10),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/login_background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Qual o seu e-mail e sua senha?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF0E4B7C),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(32, 0, 32, 0),
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText: 'Digite o CPF',
                                  labelStyle:
                                      TextStyle(color: Color(0xFF0E4B7C)),
                                  border: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF0E4B7C)),
                                  ),
                                  prefixIcon: Icon(Icons.person,
                                      color: Color(0xFF0E4B7C)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: 'Digite a senha',
                                      labelStyle:
                                          TextStyle(color: Color(0xFF0E4B7C)),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFF0E4B7C)),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Color(0xFF0E4B7C),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      print("esqueceu rapaz?");
                                    },
                                    child: const Text("Esqueceu sua senha?"),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    width: 1.0,
                                    color: Color(0xFF00AFF8),
                                    style: BorderStyle.solid,
                                  ),
                                  backgroundColor: const Color(0xFF00AFF8),
                                ),
                                onPressed: null,
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Color(0xFFFAFAFA), fontSize: 24),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18.0),
                            Center(
                                child: RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Não tem uma conta? ',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: 'Cadastre-se',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context).pushNamed(
                                          '/cadastro',
                                        );
                                      },
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
