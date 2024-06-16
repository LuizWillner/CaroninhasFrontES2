import 'package:flutter/material.dart';
import 'package:app_uff_caronas/components/bottom_bar.dart';
import 'package:app_uff_caronas/components/path_details.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_uff_caronas/services/service_auth_and_user.dart';
import 'package:app_uff_caronas/services/api_services.dart';
import 'package:intl/intl.dart';

class DetalhesCarona extends StatefulWidget {
  final String caronaId;
  const DetalhesCarona({Key? key, required this.caronaId}) : super(key: key);

  @override
  State<DetalhesCarona> createState() => _DetalhesCaronaState();
}

class _DetalhesCaronaState extends State<DetalhesCarona> {
  static const clearBlueColor = Color(0xFF00AFF8);
  static const darkBlueColor = Color(0xFF0E4B7C);
  final AuthService authService = AuthService(apiService: ApiService());
  final storage = const FlutterSecureStorage();
  dynamic user;
  var rideDetail;

  @override
  void initState() {
    super.initState();
    _fetchRide();
  }

  void _fetchRide() async {
    try {
      final ridesResponse = await authService.getRideById(widget.caronaId);

      setState(() {
        rideDetail = ridesResponse;
      });
    } catch (error) {
      print(error.toString());
    }
  }

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
                  margin:
                      const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: clearBlueColor),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                      "Foto do mapa"), // Displaying caronaId here
                ),
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
                              size: const Size(2, 3 * 30.0),
                              painter: AddressesPainter([
                                rideDetail["local_partida"],
                                "até",
                                rideDetail["local_destino"],
                              ]),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                rideDetail["local_partida"],
                                "até",
                                rideDetail["local_destino"],
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
                      Text(
                          "${DateFormat("yyyy-MM-ddTHH:mm:ss").parse(rideDetail["hora_partida"]).day}/"
                          "${DateFormat("yyyy-MM-ddTHH:mm:ss").parse(rideDetail["hora_partida"]).month}",
                          style: TextStyle(fontSize: 16.0, color: Colors.grey)),
                      Text(
                          "${DateFormat("yyyy-MM-ddTHH:mm:ss").parse(rideDetail["hora_partida"]).hour}:"
                          "${DateFormat("yyyy-MM-ddTHH:mm:ss").parse(rideDetail["hora_partida"]).day}",
                          style: TextStyle(fontSize: 16.0, color: Colors.grey)),
                      Text("R\$ ${rideDetail["valor"]},00",
                          style: TextStyle(fontSize: 16.0, color: Colors.grey)),
                      const SizedBox(height: 18.0),
                      const Text("Tipo",
                          style: TextStyle(fontSize: 16.0, color: Colors.grey)),
                      const Text("Passageiro",
                          style: TextStyle(
                              fontSize: 18.0,
                              color: darkBlueColor,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 18.0),
                      const Text("passageiros",
                          style: TextStyle(fontSize: 16.0, color: Colors.grey)),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: rideDetail["passageiros"].length,
                          itemBuilder: (context, index) {
                            final caronista = "${rideDetail["passageiros"][index]["user"]["first_name"]} ${rideDetail["passageiros"][index]["user"]["first_name"]}";
                            return Text(caronista);
                          }),
                      const SizedBox(height: 18.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 2),
    );
  }
}
