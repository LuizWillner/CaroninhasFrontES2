import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:app_uff_caronas/components/cadastro_input.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _cpfController = TextEditingController();
  TextEditingController _uffController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _password1Controller = TextEditingController();
  TextEditingController _password2Controller = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                      "Insira seus dados abaixo",
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
                          CadastroInput(
                            controller: _nameController,
                            isObscured: false,
                            placeholderText: "Nome Completo",
                            labelText: "Nome",
                            keyboardType: TextInputType.text,
                          ),
                          CadastroInput(
                            controller: _emailController,
                            isObscured: false,
                            placeholderText: "joaoSP@id.uff.br",
                            labelText: "E-mail",
                            keyboardType: TextInputType.emailAddress,
                          ),
                          CadastroInput(
                            controller: _cpfController,
                            isObscured: false,
                            placeholderText: "xxx.xxx.xxx-xx",
                            labelText: "CPF",
                            keyboardType: TextInputType.number,
                          ),
                          CadastroInput(
                            controller: _uffController,
                            isObscured: false,
                            placeholderText: "xxx.xxx.xxx",
                            labelText: "Matrícula",
                            keyboardType: TextInputType.number,
                          ),
                          Padding(padding: EdgeInsets.fromLTRB(32, 0, 32, 0),
                                  child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Data de Nascimento",
                                style: const TextStyle(
                                  color: Color(0xFF0E4B7C),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              SizedBox(
                                height: 42,
                                child: TextField(
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                  controller: _dateController,
                                  readOnly: true,
                                  keyboardType: TextInputType.datetime,
                                  decoration: InputDecoration(
                                    labelText: "xx/xx/xxxx",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    labelStyle: const TextStyle(
                                        color: Color(0xFF0E4B7C)),
                                    border: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFF0E4B7C)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ),
                          CadastroInput(
                            controller: _password1Controller,
                            isObscured: true,
                            placeholderText: "Digite aqui sua senha",
                            labelText: "Senha",
                            keyboardType: TextInputType.text,
                          ),
                          CadastroInput(
                            controller: _password2Controller,
                            isObscured: true,
                            placeholderText: "Repita aqui sua senha",
                            labelText: "Senha (repetir)",
                            keyboardType: TextInputType.text,
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
                                  text: 'Já tem uma conta? ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: 'Entrar',
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).pushNamed(
                                        '/Login',
                                      );
                                    },
                                ),
                              ],
                            ),
                          )),
                          const SizedBox(height: 18.0),
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
    );
  }
}
