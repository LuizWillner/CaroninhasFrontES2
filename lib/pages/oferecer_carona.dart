import 'package:flutter/material.dart';
import 'package:app_uff_caronas/components/bottom_bar.dart';
import 'package:app_uff_caronas/components/cadastro_input.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_uff_caronas/services/service_auth_and_user.dart';
import 'package:app_uff_caronas/services/api_services.dart';
import 'package:app_uff_caronas/components/viagem.dart';
import 'package:app_uff_caronas/components/custom_alert.dart';
import 'package:intl/intl.dart';

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
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _selectedTime = TextEditingController();
  final TextEditingController _vagasController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  late TabController _tabController;
  final AuthService authService = AuthService(apiService: ApiService());
  final storage = const FlutterSecureStorage();
  int? selectedVehicleId;
  var vehicles = [];
  var pedidos = [];

  void _fetchDriverData() async {
    try {
      final vehiclesResponse = await ApiService().getApi('veiculo/me/all');
      setState(() {
        vehicles = vehiclesResponse["data"];
      });
    } catch (error) {
      print(error.toString());
    }
  }

  void _fetchPedidos() async {
    var horaMinima = DateTime.now();
    var horaMaxima = horaMinima.add(const Duration(days: 30));
    try {
      final pedidosResponse = await ApiService().getApi(
          'pedido-carona?hora_minima=$horaMinima&hora_maxima=$horaMaxima');
      setState(() {
        pedidos = pedidosResponse["data"];
      });
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchDriverData();
    _fetchPedidos();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null) {
      setState(() {
        _selectedTime.text =
            '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
      });
    }
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
                        color: const Color(
                            0xFF00AFF8), // Cor de fundo da aba ativa
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        Container(
                          alignment: Alignment.center,
                          child: const Tab(
                            child: Text('Criar carona'),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: const Tab(
                            child: Text('Aceitar carona'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 550,
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
                            FormInput(
                              controller: _dateController,
                              isObscured: false,
                              placeholderText: "Data",
                              fieldIcon: Icons.calendar_month,
                              keyboardType: TextInputType.text,
                              onTap: () {
                                _selectDate(context);
                              },
                            ),
                            FormInput(
                              controller: _selectedTime,
                              isObscured: false,
                              placeholderText: "Hora",
                              fieldIcon: Icons.lock_clock,
                              keyboardType: TextInputType.text,
                              onTap: () {
                                _selectTime(context);
                              },
                            ),
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.65,
                                          child: DropdownButton<int>(
                                            value: selectedVehicleId,
                                            hint:
                                                const Text('Select a vehicle'),
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
                                    ),
                                  ],
                                ),
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
                                  backgroundColor: clearBlueColor,
                                ),
                                onPressed: () async {
                                  try {
                                    print(
                                        await storage.read(key: 'login_token'));
                                    final veiculoId = selectedVehicleId;
                                    final horaDePartida =
                                        DateTime.parse(_dateController.text)
                                            .add(Duration(
                                                hours: int.parse(_selectedTime
                                                    .text
                                                    .split("")[0]),
                                                minutes: int.parse(_selectedTime
                                                    .text
                                                    .split("")[1])));
                                    final precoCarona = _priceController.text;
                                    final vagas = _vagasController.text;
                                    final localPartida = _fromController.text;
                                    final localDestino = _toController.text;
                                    print(
                                        "tatatataaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n\n\n\n\n\n\n");

                                    final userStatus =
                                        await authService.createRide(
                                            veiculoId,
                                            horaDePartida,
                                            precoCarona,
                                            vagas,
                                            localPartida,
                                            localDestino);
                                    print(userStatus);
                                    print(
                                        "tatatataaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n\n\n\n\n\n\n");
                                    await storage.write(
                                        key: "isDriver", value: "true");
                                    _showMyDialog(context, "Sucesso",
                                        "Carona adicionada com sucesso");
                                  } catch (error) {
                                    _showMyDialog(context, "Erro",
                                        "Houve um erro ao adicionar o pedido de carona");
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
                        ListView.builder(
                          itemCount: pedidos.length,
                          itemBuilder: (context, index) {
                            final pedido = pedidos[index];
                            return Viagem(
                              image: "assets/login_background.png",
                              partida: pedido["local_partida"],
                              chegada: pedido["local_destino"],
                              nome: pedido["user"]["first_name"] +
                                  pedido["user"]["last_name"],
                              data: DateFormat("yyyy-MM-ddTHH:mm:ss")
                                  .parse(pedido["hora_partida_minima"]),
                              onPressed: () {
                                print(pedido["id"].runtimeType);
                                int id = pedido["id"];
                              },
                              price: pedido["valor"],
                              vagasRestantes: null,
                              buttonInnerText: "Aceitar",
                              role: "Solicitante",
                            );
                            // TODO: criar carona com o pedido
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
    );
  }

  Future<void> _showMyDialog(BuildContext context, String type, message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: type,
          titleStyle: const TextStyle(
            color: Color(0xFF0E4B7C),
            fontWeight: FontWeight.w900,
            fontSize: 30,
          ),
          content: message,
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
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(color: Color(0xFF00AFF8), width: 2),
                  ),
                ),
                // Icon(Icons.search, color: clearBlueColor),
                onPressed: () {
                  // TEM QUE ADICIONAR NO BD //
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Color(0xFF00AFF8), fontSize: 24),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
