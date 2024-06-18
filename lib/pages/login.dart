import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:app_uff_caronas/services/api_services.dart';
import 'package:app_uff_caronas/services/service_auth_and_user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final storage = const FlutterSecureStorage();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService authService = AuthService(apiService: ApiService());

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
                  color: Colors.white,
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
                            Padding(
                              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                              child: TextField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                  labelText: 'Digite seu email',
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
                                  TextField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: const InputDecoration(
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
                                    onPressed: () async {
                                      try {
                                        print(await authService.getUser());
                                      } catch (error) {
                                        print(error.toString());
                                      }
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
                                onPressed: () async {
                                  // Navigator.of(context).pushNamed(
                                  //   '/Pedir_carona',
                                  // );
                                  final username = _usernameController.text;
                                  final password = _passwordController.text;
                                  try {
                                    // TODO: mostrar loading no botão
                                    String isDriver;
                                    final token = await authService.login(
                                        username, password);
                                    await storage.write(
                                        key: "token_bearer",
                                        value:
                                            "Bearer " + token['access_token']);
                                    final user = await authService.getUser();
                                    if (user['motorista'] == null) {
                                      isDriver = "false";
                                    } else {
                                      isDriver = "true";
                                    }

                                    await storage.write(
                                        key: "isDriver", value: isDriver);

                                    final isLogged =
                                        await storage.read(key: "token_bearer");
                                    isLogged != null
                                        ? Navigator.of(context).pushNamed(
                                            '/Pedir_carona',
                                          ) //TODO Loading e mensagem de falha de login
                                        : Navigator.of(context).pushNamed(
                                            '/Login',
                                          );
                                  } catch (error) {
                                    print(error
                                        .toString()); // TODO: acusar erro na tela
                                  }
                                },
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
                                          '/Cadastro',
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
