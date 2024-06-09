import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:app_uff_caronas/components/bottom_bar.dart';
import 'package:app_uff_caronas/components/cadastro_input.dart';

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
  TextEditingController _passagersController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
                  height: MediaQuery.of(context).size.height * (4 / 10),
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
                                              initialEntryMode: TimePickerEntryMode.dial);
                                      if (timeOfDay != null) {
                                        setState(() {
                                          _selectedTime = timeOfDay;
                                        });
                                      }
                                    },
                                    child: Text(
                                        "${_selectedTime.hour}:${_selectedTime.minute}")),
                                FormInput(
                                  controller: _passagersController,
                                  isObscured: false,
                                  fieldIcon: Icons.person,
                                  placeholderText: "Passageiros",
                                  keyboardType: TextInputType.text,
                                ),
                                FormInput(
                                  controller: _priceController,
                                  isObscured: false,
                                  placeholderText: "Preço",
                                  fieldIcon: Icons.price_change,
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
                                        color: Color(0xFF00AFF8),
                                        style: BorderStyle.solid,
                                      ),
                                      backgroundColor: clearBlueColor,
                                    ),
                                    onPressed: null,
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
