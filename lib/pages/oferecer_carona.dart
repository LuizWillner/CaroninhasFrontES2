import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:app_uff_caronas/components/bottom_bar.dart';
import 'package:app_uff_caronas/components/cadastro_input.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_uff_caronas/services/service_auth_and_user.dart';
import 'package:app_uff_caronas/services/api_services.dart';

class CriarCarona extends StatefulWidget {
  const CriarCarona({Key? key}) : super(key: key);

  @override
  State<CriarCarona> createState() => _CriarCaronaState();
}

class _CriarCaronaState extends State<CriarCarona>
    with SingleTickerProviderStateMixin {
  static const clearBlueColor = Color(0xFF00AFF8);
  static const darkBlueColor = Color(0xFF0E4B7C);

  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  TextEditingController _vagasController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

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
                          tabs: [
                            Tab(child: Text('Criar carona')),
                            Tab(child: Text('Aceitar carona'))
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
                                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                height: 42,
                                                width: MediaQuery.of(context).size.width * 0.65,
                                                child: DropdownButton<int>(
                                                value: selectedVehicleId,
                                                hint: Text('Select a vehicle'),
                                                items: vehicles.map((vehicle) {
                                                  return DropdownMenuItem<int>(
                                                    value: vehicle['id'],
                                                    child: Text(vehicle['placa']),
                                                  );
                                                }).toList(),
                                                onChanged: (int? newValue) {
                                                  setState(() {
                                                    selectedVehicleId = newValue;
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
                            Text("lista de caronas")
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
}
