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
  final TextEditingController _timeMinController = TextEditingController();
  final TextEditingController _timeMaxController = TextEditingController();
  final TextEditingController _passagersController = TextEditingController();

  final TextEditingController _toCreateController = TextEditingController();
  final TextEditingController _fromCreateController = TextEditingController();
  final TextEditingController _timeMinCreateController = TextEditingController();
  final TextEditingController _timeMaxCreateController = TextEditingController();
  final TextEditingController _dateCreateController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  

  late TabController _tabController;

  final AuthService authService = AuthService(apiService: ApiService());
  final storage = const FlutterSecureStorage();
  dynamic user;
  var rides = [];

  @override
  void initState() {
    super.initState();
    _fetchRides();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _fetchRides() async {
    try {
      final ridesResponse = await authService.getRides(
                                        horaMinima: DateTime.now(),
                                        horaMaxima: DateTime.now().add(const Duration(days: 15)),
                                      );

      setState(() {
        rides = ridesResponse["data"];
      });
    } catch (error) {
      print(error.toString());
    }
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

  Future<void> _selectTimeMin(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
        initialEntryMode: TimePickerEntryMode.dial);
    if (timeOfDay != null) {
      setState(() {
        print(timeOfDay);
        _timeMinController.text =
            '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _selectTimeMax(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
        initialEntryMode: TimePickerEntryMode.dial);
    if (timeOfDay != null) {
      setState(() {
        print(timeOfDay);
        _timeMaxController.text =
            '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _selectCreateDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dateCreateController.text = picked.toString().split(" ")[0];
      });
    }
  }
    Future<void> _selectCreateTimeMin(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
        initialEntryMode: TimePickerEntryMode.dial);
    if (timeOfDay != null) {
      setState(() {
        print(timeOfDay);
        _timeMinCreateController.text = '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _selectCreateTimeMax(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
        initialEntryMode: TimePickerEntryMode.dial);
    if (timeOfDay != null) {
      setState(() {
        print(timeOfDay);
        _timeMaxCreateController.text = '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
      });
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
                          child: Text('Procurar carona'),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: const Tab(
                          child: Text('Encontrar carona'),
                        ),
                      ),Container(
                        alignment: Alignment.center,
                        child: const Tab(
                          child: Text('Pedir Carona'),
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
                                keyboardType: TextInputType.text,
                                onTap: () {
                                  _selectDate(context);
                                },
                              ),
                              FormInput(
                                controller: _timeMinController,
                                isObscured: false,
                                placeholderText: "Hora mínima",
                                fieldIcon: Icons.lock_clock,
                                keyboardType: TextInputType.text,
                                onTap: () {
                                  _selectTimeMin(context);
                                },
                              ),
                              FormInput(
                                controller: _timeMaxController,
                                isObscured: false,
                                placeholderText: "Hora máxima",
                                fieldIcon: Icons.lock_clock,
                                keyboardType: TextInputType.text,
                                onTap: () {
                                  _selectTimeMax(context);
                                },
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
                                    var horaMinima;
                                    var horaMaxima;
                                    try{
                                      horaMinima = DateFormat("yyyy-MM-dd HH:mm").parse(_dateController.text +" "+ _timeMinController.text);
                                    }catch(erro){
                                      horaMinima = DateTime.now();
                                    }
                                    try{
                                      horaMaxima = DateFormat("yyyy-MM-dd HH:mm").parse(_dateController.text +" "+ _timeMaxController.text);
                                    }catch(erro){
                                      horaMaxima = DateTime.now().add(const Duration(days: 15));
                                    }

                                    try {
                                      final response =
                                          await authService.getRides(
                                        keywordPartida: _fromController.text,
                                        keywordChegada: _toController.text,
                                        horaMinima: horaMinima,
                                        horaMaxima: horaMaxima,
                                      );
                                      setState(() {
                                        rides = response["data"];
                                      });
                                      _tabController.animateTo(1);
                                    } catch (error) {
                                      _showMyDialog(context, "Houve um erro ao procurar o pedido de carona");
                                      print(error);
                                    }
                                    if(rides.length == 0){

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
                              nome:
                                  "${ride["motorista"]["user"]["first_name"]} ${ride["motorista"]["user"]["last_name"]}",
                              data: DateFormat("yyyy-MM-ddTHH:mm:ss")
                                  .parse(ride["hora_partida"]),
                              onPressed: () {
                                print(ride["id"].runtimeType);
                                int id = ride["id"];
                                _showConfirmationDialog(context, id, ride);
                              
                              },
                              price: ride["valor"],
                              vagasRestantes: ride["vagas_restantes"],
                              buttonInnerText: "Aceitar",
                            );
                          },
                        ),
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              FormInput(
                                controller: _fromCreateController,
                                isObscured: false,
                                placeholderText: "De (endereço completo)",
                                fieldIcon: Icons.circle_outlined,
                                keyboardType: TextInputType.text,
                              ),
                              FormInput(
                                controller: _toCreateController,
                                isObscured: false,
                                placeholderText: "Para (endereço completo)",
                                fieldIcon: Icons.circle,
                                keyboardType: TextInputType.text,
                              ),
                              FormInput(
                                controller: _dateCreateController,
                                isObscured: false,
                                placeholderText: "Data",
                                fieldIcon: Icons.calendar_month,
                                keyboardType: TextInputType.text,
                                onTap: () {
                                  _selectCreateDate(context);
                                },
                              ),
                              FormInput(
                                controller: _timeMinCreateController,
                                isObscured: false,
                                placeholderText: "Hora mínima",
                                fieldIcon: Icons.lock_clock,
                                keyboardType: TextInputType.text,
                                onTap: () {
                                  _selectCreateTimeMin(context);
                                },
                              ),
                              FormInput(
                                controller: _timeMaxCreateController,
                                isObscured: false,
                                placeholderText: "Hora máxima",
                                fieldIcon: Icons.lock_clock,
                                keyboardType: TextInputType.text,
                                onTap: () {
                                  _selectCreateTimeMax(context);
                                },
                              ),
                              FormInput(
                                controller: _valueController,
                                isObscured: false,
                                fieldIcon: Icons.person,
                                placeholderText: "Valor Sugerido",
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
                                          await authService.createPedido(
                                        int.tryParse(_valueController.text)!,
                                        DateFormat("yyyy-MM-dd HH:mm").parse(_dateCreateController.text +" "+ _timeMaxCreateController.text),
                                        keywordPartida: _fromCreateController.text,
                                        keywordChegada: _toCreateController.text,
                                        horaPartidaMinima: DateFormat("yyyy-MM-dd HH:mm").parse(_dateCreateController.text +" "+ _timeMinCreateController.text),
                                      );
                                      print(response);
                                    _showMyDialog(context, "Pedido de carona criado com sucesso");

                                    } catch (error) {
                                      _showMyDialog(context, "Houve um erro ao criar pedido de carona");
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

  Future<void> _showMyDialog(BuildContext context, message) async {
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

  Future<void> _showConfirmationDialog(
      BuildContext context, int id, var ride) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: '',
          titleStyle: const TextStyle(
            color: Color(0xFF0E4B7C),
            fontWeight: FontWeight.w900,
            fontSize: 30,
          ),
          content: 'Você tem certeza que deseja aceitar essa carona?',
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
                onPressed: ()
                    //TEM QUE ADICIONAR NO BD//
                    async {
                  try {
                    await authService.caronaSubscription(ride["id"]);
                  } catch (error) {
                    print(error);
                  }
                  Navigator.of(context).pop();
                },

                child: const Text(
                  'SIM',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255), fontSize: 24),
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: Color(0xFF00AFF8), width: 2),
                    )),

                // Icon(Icons.search, color: clearBlueColor),
                onPressed: () {
                  //TEM QUE ADICIONAR NO BD//
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'NÃO',
                  style:
                      TextStyle(color: const Color(0xFF00AFF8), fontSize: 24),
                ),
              ),
            ),
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
