import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:app_uff_caronas/components/bottom_bar.dart';
import 'package:app_uff_caronas/components/path_details.dart';

class DetalhesCarona extends StatefulWidget {
  const DetalhesCarona({Key? key}) : super(key: key);

  @override
  State<DetalhesCarona> createState() => _DetalhesCaronaState();
}

class _DetalhesCaronaState extends State<DetalhesCarona> {
  static const clearBlueColor = Color(0xFF00AFF8);
  static const darkBlueColor = Color(0xFF0E4B7C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Detalhes',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: const BackButton(color: Colors.white),
          backgroundColor: clearBlueColor,
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                    height: 180.0,
                    width: 300.0,
                    margin: const EdgeInsets.only(
                        top: 20.0, left: 20.0, right: 20.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: clearBlueColor,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        color: Colors.white),
                    padding: const EdgeInsets.all(20.0),
                    child: Text("Snapshot da viagem")),
                Container(
                  width: 300.0,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: CustomPaint(
                                size: Size(2, 3 * 30.0),
                                painter: AddressesPainter([
                                  "Rua Nóbrega",
                                  "UFF - Bloco D (Faculdade de Engenharia)",
                                  "casa"
                                ]),
                              )),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "Rua Nóbrega",
                                "UFF - Bloco D (Faculdade de Engenharia)",
                                "casa"
                              ]
                                  .map((address) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20.0),
                                        child: Tooltip(
                                          message: address,
                                          child: Text(
                                            address,
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                              color: darkBlueColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines:
                                                1, // Limit the text to 1 line with ellipses if it overflows
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          )
                        ],
                      ),
                      Text("4 de maio",
                          style: const TextStyle(
                              fontSize: 16.0, color: Colors.grey)),
                      Text("14:00",
                          style: const TextStyle(
                              fontSize: 16.0, color: Colors.grey)),
                      Text("R\$ 22,90",
                          style: const TextStyle(
                              fontSize: 16.0, color: Colors.grey)),
                      const SizedBox(height: 18.0),
                      Text("Tipo",
                          style: const TextStyle(
                              fontSize: 16.0, color: Colors.grey)),
                      Text("Passageiro",
                          style: const TextStyle(
                              fontSize: 18.0,
                              color: darkBlueColor,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 18.0),
                      Text("Integrantes",
                          style: const TextStyle(
                              fontSize: 16.0, color: Colors.grey)),
                      Text("Lista da tropa",
                          style: const TextStyle(
                              fontSize: 18.0,
                              color: darkBlueColor,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 18.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
        bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2));
  }
}
