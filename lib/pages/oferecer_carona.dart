import 'package:flutter/material.dart';
import 'package:app_uff_caronas/components/bottom_bar.dart';
import 'package:app_uff_caronas/components/cadastro_input.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_uff_caronas/services/service_auth_and_user.dart';
import 'package:app_uff_caronas/services/api_services.dart';
import 'package:app_uff_caronas/components/custom_alert.dart';

class CriarCarona extends StatefulWidget {
  const CriarCarona({super.key});

  @override
  State<CriarCarona> createState() => _CriarCaronaState();
}

class _CriarCaronaState extends State<CriarCarona>
    with SingleTickerProviderStateMixin {
  static const clearBlueColor = Color(0xFF00AFF8);
  static const darkBlueColor = Color(0xFF0E4B7C);

  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  TextEditingController _vagasController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _passagersController = TextEditingController();

  late TabController _tabController;
  final AuthService authService = AuthService(apiService: ApiService());
  final storage = FlutterSecureStorage();
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
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * (4.5 / 10),
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
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.03,
                            left: 30.0,
                            right: 30.0),
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
                                child: Text('Criar carona'),
                              ),
                            ),
                            Container(
                              // width: tabWidth,
                              alignment: Alignment.center,
                              child: const Tab(
                                child: Text('Aceitar carona'),
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
                                TextButton(
                                    onPressed: () async {
                                      final DateTime? dateTime =
                                          await showDatePicker(
                                              context: context,
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(3000));
                                      if (dateTime != null) {
                                        setState(() {
                                          _selectedDate = dateTime;
                                        });
                                      }
                                    },
                                    child: Text(
                                        "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}")),
                                TextButton(
                                    onPressed: () async {
                                      final TimeOfDay? timeOfDay =
                                          await showTimePicker(
                                              context: context,
                                              initialTime: _selectedTime,
                                              initialEntryMode:
                                                  TimePickerEntryMode.dial);
                                      if (timeOfDay != null) {
                                        setState(() {
                                          _selectedTime = timeOfDay;
                                        });
                                      }
                                    },
                                    child: Text(
                                        "${_selectedTime.hour}:${_selectedTime.minute}")),
                                FormInput(
                                  controller: _vagasController,
                                  isObscured: false,
                                  fieldIcon: Icons.person,
                                  placeholderText: "Vagas",
                                  keyboardType: TextInputType.text,
                                ),
                                FormInput(
                                  controller: _priceController,
                                  isObscured: false,
                                  placeholderText: "Preço",
                                  fieldIcon: Icons.price_change,
                                  keyboardType: TextInputType.text,
                                ),
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        32, 0, 32, 16),
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                height: 42,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.65,
                                                child: DropdownButton<int>(
                                                  value: selectedVehicleId,
                                                  hint:
                                                      Text('Select a vehicle'),
                                                  items:
                                                      vehicles.map((vehicle) {
                                                    return DropdownMenuItem<
                                                        int>(
                                                      value: vehicle['id'],
                                                      child: Text(
                                                          vehicle['placa']),
                                                    );
                                                  }).toList(),
                                                  onChanged: (int? newValue) {
                                                    setState(() {
                                                      selectedVehicleId =
                                                          newValue;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )),
                                const SizedBox(height: 16.0),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(24, 0, 24, 0),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        width: 1.0,
                                        color: Color(0xFF00AFF8),
                                        style: BorderStyle.solid,
                                      ),
                                      backgroundColor: clearBlueColor,
                                    ),
                                    onPressed: () async {
                                      print(await storage.read(
                                          key: 'login_token'));
                                      final veiculoId = selectedVehicleId;
                                      final horaDePartida = _selectedDate.add(
                                          Duration(
                                              hours: _selectedTime.hour,
                                              minutes: _selectedTime.minute));
                                      final precoCarona = _priceController.text;
                                      final vagas = _vagasController.text;
                                      final localPartida = _fromController.text;
                                      final localDestino = _toController.text;

                                      try {
                                        final user_status =
                                            await authService.createRide(
                                                veiculoId,
                                                horaDePartida,
                                                precoCarona,
                                                vagas,
                                                localPartida,
                                                localDestino);
                                        print(user_status);
                                        await storage.write(
                                            key: "isDriver", value: "true");
                                        _showMyDialog(context);
                                      } catch (error) {
                                        print(error);
                                      }
                                    },
                                    child: const Text(
                                      'Oferecer',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18.0),
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
