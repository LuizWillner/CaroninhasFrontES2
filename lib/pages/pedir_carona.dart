import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:app_uff_caronas/components/bottom_bar.dart';
import 'package:app_uff_caronas/components/cadastro_input.dart';

class PedirCarona extends StatefulWidget {
  const PedirCarona({Key? key}) : super(key: key);

  @override
  State<PedirCarona> createState() => _PedirCaronaState();
}

class _PedirCaronaState extends State<PedirCarona> {
  static const clearBlueColor = Color(0xFF00AFF8);
  static const darkBlueColor = Color(0xFF0E4B7C);

  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _passagersController = TextEditingController();

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
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Center(
                        child: Text(
                          "Viagens com preços baixos para você",
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
                      margin: const EdgeInsets.only(
                          top: 120.0, left: 30.0, right: 30.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: clearBlueColor,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: Colors.white),
                      padding: const EdgeInsets.only(top: 20.0),
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
                            placeholderText: "Hoje",
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
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
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
                                Navigator.of(context).pushNamed('/Pedindo_carona')
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
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0));
  }
}
