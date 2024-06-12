
import 'package:flutter/material.dart';
import 'package:app_uff_caronas/components/bottom_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_uff_caronas/services/service_auth.dart';
import 'package:app_uff_caronas/services/api_services.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  static const clearBlueColor = Color(0xFF00AFF8);
  static const darkBlueColor = Color(0xFF0E4B7C);
  final AuthService authService = AuthService(apiService: ApiService());
  final storage = const FlutterSecureStorage();
  var _loading = true;
  dynamic user;
  late List<dynamic> vehicles = [
    {
      "placa": "DOG4444",
      "created_at": "2024-05-26T22:42:00.693969",
      "veiculo": {
        "tipo": "CARRO",
        "marca": "MITSUBISHI",
        "modelo": "LANCER",
        "cor": "BRANCO",
        "id": 2,
        "created_at": "2024-05-26T22:42:00.653325"
      },
      "id": 2,
      "fk_motorista": 22,
      "fk_veiculo": 2
    }
  ];

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

  void _fetchDriverData() async {
    try {
      vehicles = (await ApiService().getApi('veiculo/me/all')) as List;
      setState(() {
        _loading = false;
      });
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
            'Meu perfil', // trocar para nome da pessoa qnd for perfil de outro user
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: const BackButton(color: Colors.white),
          backgroundColor: clearBlueColor,
        ),
        body: _loading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: SizedBox(
                    child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 16.0),
                          Row(
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 85.0,
                                    child: ClipOval(
                                        child: Image.network(
                                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0sCAvrW1yFi0UYMgTZb113I0SwtW0dpby8Q&usqp=CAU')),
                                  ),
                                  const Text(
                                    "Alterar imagem",
                                    style: TextStyle(color: darkBlueColor),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Nome',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: darkBlueColor,
                                        height: 0.5),
                                  ),
                                  Text(
                                    user['first_name'] +
                                        ' ' +
                                        user['last_name'],
                                    style: const TextStyle(
                                        fontSize: 24.0,
                                        color: darkBlueColor,
                                        fontWeight: FontWeight.bold,
                                        height: 1.0),
                                  ),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    'Email',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: darkBlueColor,
                                        height: 0.5),
                                  ),
                                  Text(
                                    user['email'],
                                    style: const TextStyle(
                                        fontSize: 24.0,
                                        color: darkBlueColor,
                                        fontWeight: FontWeight.bold,
                                        height: 1.0),
                                  ),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    'Telefone',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: darkBlueColor,
                                        height: 0.5),
                                  ),
                                  Text(
                                    user['phone'],
                                    style: const TextStyle(
                                        fontSize: 24.0,
                                        color: darkBlueColor,
                                        fontWeight: FontWeight.bold,
                                        height: 1.0),
                                  ),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    'Rating',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: darkBlueColor,
                                        height: 0.5),
                                  ),
                                  const SizedBox(height: 8.0),
                                  const Text(
                                    // TODO: adicionar nota no modelo do banco
                                    '4.8' ' ⭐',
                                    style: TextStyle(
                                        fontSize: 24.0,
                                        color: darkBlueColor,
                                        fontWeight: FontWeight.bold,
                                        height: 0.5),
                                  ),
                                  const SizedBox(height: 32.0),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 32.0),
                          const Text(
                            'Área do Motorista',
                            style: TextStyle(
                                fontSize: 28.0,
                                color: darkBlueColor,
                                fontWeight: FontWeight.bold,
                                height: 0.5),
                          ),
                          user['motorista'] == null
                              ? const Text(
                                  "Tem um carro? cadastre-se como motorista!")
                              : vehicles == []
                                  ? const Text("Cadastre um novo carro!")
                                  : Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 150.0,
                                            child: ListView.builder(
                                              itemCount: vehicles.length,
                                              itemBuilder: (context, index) {
                                                final vehicle = vehicles[index];
                                                final veiculoDetails =
                                                    vehicle['veiculo'];
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.fromLTRB(
                                                            10, 10, 10, 5),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                              'Carro atual',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  color:
                                                                      darkBlueColor,
                                                                  height: 0.5),
                                                            ),
                                                            Text(
                                                              '${veiculoDetails['marca']} ${veiculoDetails['modelo']}',
                                                              style: const TextStyle(
                                                                fontSize: 20.0,
                                                                color:
                                                                    darkBlueColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                height: 1.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.fromLTRB(
                                                            10, 10, 10, 5),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                              'Placa',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  color:
                                                                      darkBlueColor,
                                                                  height: 0.5),
                                                            ),
                                                            Text(
                                                              vehicle['placa'],
                                                              style: const TextStyle(
                                                                fontSize: 24.0,
                                                                color:
                                                                    darkBlueColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                height: 1.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.fromLTRB(
                                                            10, 10, 10, 5),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                              'Cor',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  color:
                                                                      darkBlueColor,
                                                                  height: 0.5),
                                                            ),
                                                            Text(
                                                              veiculoDetails[
                                                                  'cor'],
                                                              style: const TextStyle(
                                                                fontSize: 18.0,
                                                                color:
                                                                    darkBlueColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                height: 1.0,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 24,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                          Column(
                            // retirar qnd for perfil de outro user
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 60.0,
                              ),
                              TextButton(
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero),
                                  onPressed: () {
                                    print('k');
                                  },
                                  child: const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Histórico de caronas',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey,
                                        height: 0.5,
                                      ),
                                    ),
                                  )),
                              const Divider(
                                color: Colors.grey,
                              ),
                              TextButton(
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero),
                                  onPressed: () {
                                    print('k');
                                  },
                                  child: const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Alterar senha',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey,
                                        height: 0.5,
                                      ),
                                    ),
                                  )),
                              const Divider(
                                color: Colors.grey,
                              ),
                              // TextButton(
                              //     style: TextButton.styleFrom(
                              //         padding: EdgeInsets.zero),
                              //     onPressed: () {
                              //       print('k');
                              //     },
                              //     child: const Align(
                              //       alignment: Alignment.centerLeft,
                              //       child: Text(
                              //         'Alterar email',
                              //         style: TextStyle(
                              //           fontSize: 14.0,
                              //           color: Colors.grey,
                              //           height: 0.5,
                              //         ),
                              //       ),
                              //     )),
                              // const Divider(
                              //   color: Colors.grey,
                              // ),
                              TextButton(
                                  // TODO: prompt de logoff
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero),
                                  onPressed: () async {
                                    await storage.delete(key: "token_bearer");
                                    Navigator.of(context).pushNamed(
                                      '/Login',
                                    );
                                  },
                                  child: const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Sair',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey,
                                        height: 0.5,
                                      ),
                                    ),
                                  )),
                              const Divider(
                                color: Colors.grey,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                )),
              ),
        bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 4));
  }
}