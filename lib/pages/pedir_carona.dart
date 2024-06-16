import 'dart:math';
import 'package:flutter/material.dart';
import 'package:app_uff_caronas/components/bottom_bar.dart';
import 'package:app_uff_caronas/components/cadastro_input.dart';
import 'package:app_uff_caronas/components/custom_alert.dart';
import 'package:app_uff_caronas/components/viagem.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_uff_caronas/services/service_auth_and_user.dart';
import 'package:app_uff_caronas/services/api_services.dart';
import 'package:intl/intl.dart';

class PedirCarona extends StatefulWidget {
  const PedirCarona({super.key});

  @override
  State<PedirCarona> createState() => _PedirCaronaState();
}

class _PedirCaronaState extends State<PedirCarona>
    with SingleTickerProviderStateMixin {
  static const clearBlueColor = Color(0xFF00AFF8);
  static const darkBlueColor = Color(0xFF0E4B7C);

  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _passagersController = TextEditingController();

  late TabController _tabController;

  final AuthService authService = AuthService(apiService: ApiService());
  final storage = const FlutterSecureStorage();
  dynamic user;
  var rides = [];

  @override
  void initState() {
    super.initState();
    _fetchRides();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _fetchRides() async {
    try {
      final ridesResponse = await authService.getAllRides();

      setState(() {
        rides = ridesResponse["data"];
      });
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * (5 / 10),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/login_background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: Center(
                    child: Text(
                      "Está procurando uma caroninha?",
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.03,
                    left: 30.0,
                    right: 30.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: clearBlueColor,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color(0xFF00AFF8),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      Container(
                        alignment: Alignment.center,
                        child: const Tab(
                          child: Text('Pedir carona'),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: const Tab(
                          child: Text('Encontrar carona'),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: clearBlueColor,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.only(top: 20.0),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              FormInput(
                                controller: _fromController,
                                isObscured: false,
                                placeholderText: "De (endereço completo)",
                                fieldIcon: Icons.circle_outlined,
                                keyboardType: TextInputType.text,
                              ),
                              FormInput(
                                controller: _toController,
                                isObscured: false,
                                placeholderText: "Para (endereço completo)",
                                fieldIcon: Icons.circle,
                                keyboardType: TextInputType.text,
                              ),
                              FormInput(
                                controller: _dateController,
                                isObscured: false,
                                placeholderText: "Data",
                                fieldIcon: Icons.calendar_month,
                                keyboardType: TextInputType.datetime,
                              ),
                              FormInput(
                                controller: _timeController,
                                isObscured: false,
                                placeholderText: "Hora",
                                fieldIcon: Icons.lock_clock,
                                keyboardType: TextInputType.number,
                              ),
                              FormInput(
                                controller: _passagersController,
                                isObscured: false,
                                fieldIcon: Icons.person,
                                placeholderText: "Passageiros",
                                keyboardType: TextInputType.text,
                              ),
                              const SizedBox(height: 16.0),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(24, 0, 24, 0),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                      width: 1.0,
                                      color: clearBlueColor,
                                      style: BorderStyle.solid,
                                    ),
                                    backgroundColor: clearBlueColor,
                                  ),
                                  onPressed: () async {
                                    try {
                                      final response =
                                          await authService.getRides(
                                        keywordPartida: _fromController.text,
                                        keywordChegada: _toController.text,
                                      );
                                      setState(() {
                                        rides = response["data"];
                                      });
                                      _tabController.animateTo(1);
                                    } catch (error) {
                                      _showMyDialog(context);
                                      print(error);
                                    }
                                  },
                                  child: const Text(
                                    'Procurar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18.0),
                            ],
                          ),
                        ),
                        ListView.builder(
                          itemCount: rides.length,
                          itemBuilder: (context, index) {
                            final ride = rides[index];
                            return Viagem(
                              image: "assets/login_background.png",
                              partida: ride["local_partida"],
                              chegada: ride["local_destino"],
                              nome: ride["motorista"]["user"]["first_name"] +
                                  ride["motorista"]["user"]["last_name"],
                              data: DateFormat("yyyy-MM-ddTHH:mm:ss")
                                  .parse(ride["hora_partida"]),
                              onPressed: () async {
                                try {
                                  await authService
                                      .caronaSubscription(ride["id"]);
                                } catch (error) {
                                  print(error);
                                }
                              },
                              price: ride["valor"],
                              vagasRestantes: ride["vagas_restantes"],
                              buttonInnerText: "Aceitar",
                            ); // Replace this with your actual widget to display ride information
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 0),
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Sucesso',
          titleStyle: const TextStyle(
            color: Color(0xFF0E4B7C),
            fontWeight: FontWeight.w900,
            fontSize: 30,
          ),
          content: 'Houve um erro ao procurar o pedido de carona',
          contentStyle: const TextStyle(
            color: Color(0xFF0E4B7C),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          actions: <Widget>[
            SizedBox(
              width: 100,
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF00AFF8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    )),
                // Icon(Icons.search, color: clearBlueColor),
                onPressed: () {
                  //TEM QUE ADICIONAR NO BD//
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255), fontSize: 24),
                ),
              ),
            )
          ],
        );
      },
    );
  }
  // Future<void> _showConfirmationDialog(BuildContext context) async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Confirmação'),
  //         content: Text('Você deseja prosseguir?'),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('Cancelar'),
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Fecha o diálogo de confirmação
  //             },
  //           ),
  //           TextButton(
  //             child: Text('Prosseguir'),
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Fecha o diálogo de confirmação
  //               _showSuccessDialog(context); // Abre o diálogo de sucesso
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // Future<void> _showSuccessDialog(BuildContext context) async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Sucesso'),
  //         content: Text('Adicionado com sucesso!'),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('OK'),
  //             onPressed: () {
  //               Navigator.of(context).pop(); // Fecha o diálogo de sucesso
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
