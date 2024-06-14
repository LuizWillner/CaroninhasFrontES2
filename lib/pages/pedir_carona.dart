import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:app_uff_caronas/components/bottom_bar.dart';
import 'package:app_uff_caronas/components/cadastro_input.dart';
import 'package:app_uff_caronas/components/viagem.dart';

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
                            top: MediaQuery.of(context).size.height * 0.03, left: 30.0, right: 30.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: clearBlueColor,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color: Colors.white),
                        child: TabBar(
                          controller: _tabController,
                          tabs: const [
                            Tab(child: Text('Pedir carona')),
                            Tab(child: Text('Encontrar carona'))
                          ],
                        )),
                    Container(
                      height: 400,
                        margin: const EdgeInsets.only(
                            left: 30.0, right: 30.0),
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
                                    onPressed: () => {
                                      Navigator.of(context)
                                          .pushNamed('/Pedindo_carona')
                                    },
                                    child: const Text(
                                      'Procurar',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18.0),
                              ],
                            ),
                            SingleChildScrollView(child: Column(children: [
                              Viagem(image: "assets/login_background.png", endereco: "baleia", nome: "ggeold", data: DateTime.now(), onPressed: () => {}, price: 34),
                              Viagem(image: "assets/login_background.png", endereco: "baleia", nome: "ggeold", data: DateTime.now(), onPressed: () => {}, price: 34),
                            ],),)
                            
                          ],
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 0));
  }
}
