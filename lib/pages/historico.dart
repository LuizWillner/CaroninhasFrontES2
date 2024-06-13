import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:app_uff_caronas/components/bottom_bar.dart';
import 'package:app_uff_caronas/components/cadastro_input.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_uff_caronas/services/service_auth_and_user.dart';
import 'package:app_uff_caronas/services/api_services.dart';
import 'package:app_uff_caronas/components/custom_alert.dart';
import 'package:app_uff_caronas/components/viagem.dart';

class Historico extends StatefulWidget {
  const Historico({super.key});

  @override
  State<Historico> createState() => _HistoricoState();
}

class _HistoricoState extends State<Historico>
    with SingleTickerProviderStateMixin {
  static const clearBlueColor = Color(0xFF00AFF8);
  static const darkBlueColor = Color(0xFF0E4B7C);

  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final TextEditingController _vagasController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _passagersController = TextEditingController();

  late TabController _tabController;
  final AuthService authService = AuthService(apiService: ApiService());
  final storage = const FlutterSecureStorage();
  int? selectedVehicleId;
  var vehicles = [];
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

  late List<dynamic> mockVehicles = [
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
    },
    {
      "placa": "penisdenis",
      "created_at": "2024-05-26T22:42:00.693969",
      "veiculo": {
        "tipo": "CARRO",
        "marca": "MITSUBISHI",
        "modelo": "LANCER",
        "cor": "BRANCO",
        "id": 4,
        "created_at": "2024-05-26T22:42:00.653325"
      },
      "id": 4,
      "fk_motorista": 22,
      "fk_veiculo": 4
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchDriverData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double tabWidth = ((MediaQuery.of(context).size.width + 120));

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Suas Viagens',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: const BackButton(color: Colors.white),
          backgroundColor: clearBlueColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Stack(
              children: [
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 0.0),
                      child: Center(
                        child: Text(
                          "Dê uma caroninha pra que ta precisando!", // TODO: mudar cor do fundo
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
                        margin: EdgeInsets.only(left: 30.0, right: 30.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: clearBlueColor,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color: Colors.white),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                50), // Ajusta o raio de borda conforme necessário
                            color: const Color(
                                0xFF00AFF8), // Cor de fundo da aba ativa
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.black,
                          tabs: [
                            Container(
                              // width: tabWidth + 120,
                              alignment: Alignment.center,
                              child: const Tab(
                                child: Text('Corridas Atuais'),
                              ),
                            ),
                            Container(
                              // width: tabWidth,
                              alignment: Alignment.center,
                              child: const Tab(
                                child: Text('Histórico'),
                              ),
                            ),
                          ],
                        )),
                    Container(
                        height: 450,
                        margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: clearBlueColor,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color: Colors.white),
                        padding: const EdgeInsets.only(top: 20.0),
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Column(
                              children: [
                                Viagem(
                                  image: 'assets/login_background.png',
                                  endereco: 'text teste 344444',
                                  nome: 'text teste',
                                  data: DateTime.now(),
                                  onPressed: () {
                                    print("tututu");
                                  },
                                  price: 1,
                                ),
                                const Text("data"),
                              ],
                            ),
                            const Text("lista de caronas")
                          ],
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 1));
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
          content: 'Carona criada com sucesso (Motorista)',
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
}
