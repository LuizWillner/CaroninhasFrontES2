import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:app_uff_caronas/components/bottom_bar.dart';
import 'package:app_uff_caronas/components/path_details.dart';

class PedindoCarona extends StatefulWidget {
  const PedindoCarona({Key? key}) : super(key: key);

  @override
  State<PedindoCarona> createState() => _PedindoCaronaState();
}

class _PedindoCaronaState extends State<PedindoCarona> {
  static const clearBlueColor = Color(0xFF00AFF8);
  static const darkBlueColor = Color(0xFF0E4B7C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Visualização do Trajeto',
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
            height: MediaQuery.of(context).size.height - 115,
            color: Colors.white,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * (6 / 10),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/login_background.png'), // maps
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                    left: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
                      child: Column(
                        children: [
                          const Text("Procurando caronas...",
                              style: TextStyle(
                                fontSize: 22.0,
                                color: darkBlueColor,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.left),
                          const Divider(),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 40.0, right: 40.0, top: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: CustomPaint(
                                    size: const Size(2, 3 * 30.0),
                                    // Mocked AddressesPainter with 3 addresses
                                    painter: AddressesPainter([
                                      "Rua Nóbrega",
                                      "UFF - Bloco D (Faculdade de Engenharia)",
                                      "casa"
                                    ]),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      "Rua Nóbrega",
                                      "UFF - Bloco D (Faculdade de Engenharia)",
                                      "casa"
                                    ]
                                        .map((address) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 20.0),
                                              child: Tooltip(
                                                message: address,
                                                child: Text(
                                                  address,
                                                  style: const TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors
                                                        .black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 0));
  }
}
