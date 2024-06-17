import 'package:flutter/material.dart';
import 'package:app_uff_caronas/components/bottom_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_uff_caronas/services/service_auth_and_user.dart';
import 'package:app_uff_caronas/services/api_services.dart';

class AlterarDados extends StatefulWidget {
  const AlterarDados({super.key});

  @override
  State<AlterarDados> createState() => _AlterarDadosState();
}

class _AlterarDadosState extends State<AlterarDados> {
  static const clearBlueColor = Color(0xFF00AFF8);
  static const darkBlueColor = Color(0xFF0E4B7C);
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _passwordOldController = TextEditingController();
  TextEditingController _password1Controller = TextEditingController();
  TextEditingController _password2Controller = TextEditingController();
  final AuthService authService = AuthService(apiService: ApiService());
  final storage = const FlutterSecureStorage();
  dynamic userInfo;
  bool loading = true;

  void _fetchUserData() async {
    try {
      final user = await authService.getUser();
      setState(() {
        userInfo = user;
      });
    } catch (error) {
      print(error.toString());
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Alterar dados', // trocar para nome da pessoa qnd for perfil de outro user
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: const BackButton(color: Colors.white),
          backgroundColor: clearBlueColor,
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: SizedBox(
                    child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                              child: TextField(
                                controller: _firstNameController,
                                //initialValue: userInfo['first_name'],
                                decoration: const InputDecoration(
                                  labelText: 'Primeiro Nome',
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
                              child: TextField(
                                controller: _lastNameController,
                                //initialValue: userInfo['last_name'],
                                decoration: const InputDecoration(
                                  labelText: 'Sobrenome',
                                  labelStyle:
                                      TextStyle(color: Color(0xFF0E4B7C)),
                                  border: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF0E4B7C)),
                                  ),
                                  prefixIcon: Icon(Icons.person_2,
                                      color: Color(0xFF0E4B7C)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                              child: TextField(
                                controller: _passwordOldController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Senha antiga',
                                  labelStyle:
                                      TextStyle(color: Color(0xFF0E4B7C)),
                                  border: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF0E4B7C)),
                                  ),
                                  prefixIcon: Icon(Icons.lock,
                                      color: Color(0xFF0E4B7C)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                              child: TextField(
                                controller: _password1Controller,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Senha nova',
                                  labelStyle:
                                      TextStyle(color: Color(0xFF0E4B7C)),
                                  border: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF0E4B7C)),
                                  ),
                                  prefixIcon: Icon(Icons.lock,
                                      color: Color(0xFF0E4B7C)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                              child: TextField(
                                controller: _password2Controller,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Repetir a senha nova',
                                  labelStyle:
                                      TextStyle(color: Color(0xFF0E4B7C)),
                                  border: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF0E4B7C)),
                                  ),
                                  prefixIcon: Icon(Icons.lock,
                                      color: Color(0xFF0E4B7C)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  width: 1.0,
                                  color: Color(0xFF00AFF8),
                                  style: BorderStyle.solid,
                                ),
                                backgroundColor: const Color(0xFF00AFF8),
                              ),
                              onPressed: () async {
                                print(await storage.read(key: 'login_token'));
                                var firstName = _firstNameController.text;
                                var lastName = _lastNameController.text;
                                final passwordOld = _passwordOldController.text;
                                final password1 = _password1Controller.text;
                                final password2 = _password2Controller.text;

                                if (firstName == "") {
                                  firstName = userInfo['first_name'];
                                }
                                if (lastName == "") {
                                  lastName = userInfo['last_name'];
                                }

                                try {
                                  final userStatus =
                                      await authService.updateUserInfo(
                                          firstName,
                                          lastName,
                                          userInfo['birthdate'],
                                          passwordOld,
                                          password1);
                                  print(userStatus);
                                } catch (error) {
                                  print(error);
                                }
                              },
                              child: const Text(
                                'Atualizar',
                                style: TextStyle(
                                    color: Color(0xFFFAFAFA), fontSize: 24),
                              ),
                            ),
                          ],
                        )))),
        bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 3));
  }
}
