import 'package:flutter/material.dart';
import 'package:app_uff_caronas/components/bottom_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_uff_caronas/services/service_auth_and_user.dart';
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
  var vehicles = [];
  var rating = 5.0;

  void _fetchUserData() async {
    try {
      user = await authService.getUser();
      _fetchRating(user["id"]);
      if (user['motorista'] != null) {
        setState(() {
          _loading = false;
        });
        _fetchDriverData();
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
      final vehiclesResponse = (await ApiService().getApi('veiculo/me/all'));
      setState(() {
        vehicles = vehiclesResponse["data"];
      });
    } catch (error) {
      print(error.toString());
    }
  }

  void _fetchRating(id) async {
    try {
      final ratingResponse =
          (await ApiService().getApi('avaliacao/passageiro/$id'));
      setState(() {
        if (ratingResponse["data"]["nota_media"] != null) {
          rating = ratingResponse["data"];
        }
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
    var fontSize = MediaQuery.of(context).size.width * 0.05;

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
            ? const Center(child: CircularProgressIndicator())
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
                                    radius: MediaQuery.of(context).size.width *
                                        0.18,
                                    child: ClipOval(
                                        child: Image.network(
                                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0sCAvrW1yFi0UYMgTZb113I0SwtW0dpby8Q&usqp=CAU')),
                                  ),
                                  Text(
                                    "Alterar imagem",
                                    style: TextStyle(
                                        color: darkBlueColor.withOpacity(0.5)),
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
                                        height: 0.8),
                                  ),
                                  Text(
                                    user['first_name'] +
                                        ' ' +
                                        user['last_name'],
                                    style: TextStyle(
                                        fontSize: fontSize,
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
                                        height: 0.8),
                                  ),
                                  Text(
                                    user['email'],
                                    style: TextStyle(
                                        fontSize: fontSize,
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
                                        height: 0.8),
                                  ),
                                  Text(
                                    user['phone'],
                                    style: TextStyle(
                                        fontSize: fontSize,
                                        color: darkBlueColor,
                                        fontWeight: FontWeight.bold,
                                        height: 1.0),
                                  ),
                                  const SizedBox(height: 16.0),
                                  const Text(
                                    'Avaliação',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: darkBlueColor,
                                        height: 0.8),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    '${rating.toStringAsFixed(1)} ⭐',
                                    style: TextStyle(
                                        fontSize: fontSize,
                                        color: darkBlueColor,
                                        fontWeight: FontWeight.bold,
                                        height: 0.8),
                                  ),
                                  const SizedBox(height: 32.0),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 32.0),
                          user['motorista'] == null
                              ? Column(
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 16, 0, 16),
                                      child: Text(
                                          "No momento você não tem nenhum carro. Cadastre seu carro e torne-se um motorista!"),
                                    ),
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          width: 1.0,
                                          color: Color(0xFF00AFF8),
                                          style: BorderStyle.solid,
                                        ),
                                        backgroundColor:
                                            const Color(0xFF00AFF8),
                                      ),
                                      onPressed: () async {
                                        Navigator.of(context).pushNamed(
                                          '/Adicionar_carro',
                                        );
                                      },
                                      child: const Text(
                                        'Cadastro Motorista',
                                        style: TextStyle(
                                            color: Color(0xFFFAFAFA),
                                            fontSize: 24),
                                      ),
                                    )
                                  ],
                                )
                              : vehicles == []
                                  ? const Text("Cadastre um novo carro!")
                                  : Column(
                                      children: [
                                        const Text(
                                          'Carros do Motorista',
                                          style: TextStyle(
                                              fontSize: 28.0,
                                              color: darkBlueColor,
                                              fontWeight: FontWeight.bold,
                                              height: 0.5),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                width: 1.0,
                                                color: Color(0xFF00AFF8),
                                                style: BorderStyle.solid,
                                              ),
                                              backgroundColor:
                                                  const Color(0xFF00AFF8),
                                            ),
                                            onPressed: () async {
                                              Navigator.of(context).pushNamed(
                                                '/Adicionar_carro',
                                              );
                                            },
                                            child: const Text(
                                              'Adicionar Carro',
                                              style: TextStyle(
                                                  color: Color(0xFFFAFAFA),
                                                  fontSize: 24),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                height: 150.0,
                                                child: ListView.builder(
                                                  itemCount: vehicles.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final vehicle =
                                                        vehicles[index];
                                                    final veiculoDetails =
                                                        vehicle['veiculo'];
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    10,
                                                                    10,
                                                                    10,
                                                                    5),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          4),
                                                                  child: Text(
                                                                    'Carro atual',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14.0,
                                                                        color:
                                                                            darkBlueColor,
                                                                        height:
                                                                            0.5),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '${veiculoDetails['marca']} ${veiculoDetails['modelo']}',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        20.0,
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
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    10,
                                                                    10,
                                                                    10,
                                                                    5),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          4),
                                                                  child: Text(
                                                                    'Placa',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14.0,
                                                                        color:
                                                                            darkBlueColor,
                                                                        height:
                                                                            0.5),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  vehicle[
                                                                      'placa'],
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        24.0,
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
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    10,
                                                                    10,
                                                                    10,
                                                                    5),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          4),
                                                                  child: Text(
                                                                    'Cor',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14.0,
                                                                        color:
                                                                            darkBlueColor,
                                                                        height:
                                                                            0.5),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  veiculoDetails[
                                                                      'cor'],
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        18.0,
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
                                      ],
                                    ),
                          Column(
                            // retirar qnd for perfil de outro user
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 30.0,
                              ),
                              const Divider(
                                color: Colors.grey,
                              ),
                              TextButton(
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero),
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                      '/Alterar_dados',
                                    );
                                  },
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Alterar dados',
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
        bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 3));
  }
}
