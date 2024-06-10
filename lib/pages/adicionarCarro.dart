import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:app_uff_caronas/components/bottom_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_uff_caronas/services/service_auth_and_user.dart';
import 'package:app_uff_caronas/services/api_services.dart';

class AdicionarCarro extends StatefulWidget {
  const AdicionarCarro({super.key});

  @override
  State<AdicionarCarro> createState() => _AdicionarCarroState();
}

class _AdicionarCarroState extends State<AdicionarCarro> {
  static const clearBlueColor = Color(0xFF00AFF8);
  static const darkBlueColor = Color(0xFF0E4B7C);
  TextEditingController _cnhController = TextEditingController();
  TextEditingController _marcaController = TextEditingController();
  TextEditingController _modeloController = TextEditingController();
  TextEditingController _corController = TextEditingController();
  TextEditingController _placaController = TextEditingController();
  final AuthService authService = AuthService(apiService: ApiService());
  final storage = FlutterSecureStorage();
  var _loading = true;
  dynamic user;

  void _fetchUserData() async {
    try {
      user = await authService.getUser();
      if (user['motorista'] != null) {
        setState(() {
          _loading = false;
        });
        // _fetchDriverData();
      } else {
        setState(() {
          _loading = false;
        });
      }
    } catch (error) {
      print(error.toString());
    }
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
            'Adicionar Carro', // trocar para nome da pessoa qnd for perfil de outro user
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: const BackButton(color: Colors.white),
          backgroundColor: clearBlueColor,
        ),
        body: SingleChildScrollView(
            child: SizedBox(
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                          child: TextField(
                            controller: _cnhController,
                            decoration: const InputDecoration(
                              labelText: 'CNH',
                              labelStyle: TextStyle(color: Color(0xFF0E4B7C)),
                              border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF0E4B7C)),
                              ),
                              prefixIcon: Icon(Icons.car_repair,
                                  color: Color(0xFF0E4B7C)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                          child: TextField(
                            controller: _marcaController,
                            decoration: const InputDecoration(
                              labelText: 'Marca',
                              labelStyle: TextStyle(color: Color(0xFF0E4B7C)),
                              border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF0E4B7C)),
                              ),
                              prefixIcon: Icon(Icons.car_repair,
                                  color: Color(0xFF0E4B7C)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                          child: TextField(
                            controller: _modeloController,
                            decoration: const InputDecoration(
                              labelText: 'Modelo',
                              labelStyle: TextStyle(color: Color(0xFF0E4B7C)),
                              border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF0E4B7C)),
                              ),
                              prefixIcon: Icon(Icons.car_repair,
                                  color: Color(0xFF0E4B7C)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                          child: TextField(
                            controller: _corController,
                            decoration: const InputDecoration(
                              labelText: 'Cor',
                              labelStyle: TextStyle(color: Color(0xFF0E4B7C)),
                              border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF0E4B7C)),
                              ),
                              prefixIcon: Icon(Icons.car_repair,
                                  color: Color(0xFF0E4B7C)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                          child: TextField(
                            controller: _placaController,
                            decoration: const InputDecoration(
                              labelText: 'Placa',
                              labelStyle: TextStyle(color: Color(0xFF0E4B7C)),
                              border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF0E4B7C)),
                              ),
                              prefixIcon: Icon(Icons.car_repair,
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
                            final marca = _marcaController.text;
                            final modelo = _modeloController.text;
                            final cor = _corController.text;
                            final placa = _placaController.text;
                            final cnh = _cnhController.text;

                            try {
                              final user_status =
                                  await authService.becomeMotorist(cnh);
                              print(user_status);
                              await storage.write(
                                  key: "isDriver", value: "true");
                            } catch (error) {
                              print(error);
                            }

                            try {
                              final car = await authService.createCar(
                                  marca, modelo, cor, placa);
                              print(car);
                              Navigator.of(context).pushNamed(
                                '/Perfil',
                              );
                            } catch (error) {
                              print(error);
                            }
                          },
                          child: const Text(
                            'Adicionar',
                            style: TextStyle(
                                color: Color(0xFFFAFAFA), fontSize: 24),
                          ),
                        ),
                      ],
                    )))),
        bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 4));
  }
}
