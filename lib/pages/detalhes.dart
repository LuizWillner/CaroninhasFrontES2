import 'package:flutter/material.dart';
import 'package:app_uff_caronas/components/bottom_bar.dart';
import 'package:app_uff_caronas/components/path_details.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_uff_caronas/services/service_auth_and_user.dart';
import 'package:app_uff_caronas/services/api_services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:app_uff_caronas/components/custom_alert.dart';

class DetalhesCarona extends StatefulWidget {
  final String caronaId;
  const DetalhesCarona({super.key, required this.caronaId});

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
    _fetchUserData();
  }

  void _fetchUserData() async {
    try {
      user = await authService.getUser();
      print('user["id"]');
      print(user["id"]);
    } catch (error) {
      print(error.toString());
    }
  }

  void _fetchRide() async {
    try {
      final ridesResponse = await authService.getRideById(widget.caronaId);
      print('ridesResponse["fk_motorista"]');
      print(ridesResponse['motorista']['id_fk_user']);
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
                  child: const Text("Foto do mapa"),
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
                                            maxLines: 1,
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
                          style: const TextStyle(
                              fontSize: 16.0, color: Colors.grey)),
                      Text(
                          "${DateFormat("yyyy-MM-ddTHH:mm:ss").parse(rideDetail["hora_partida"]).hour}:"
                          "${DateFormat("yyyy-MM-ddTHH:mm:ss").parse(rideDetail["hora_partida"]).day}",
                          style: const TextStyle(
                              fontSize: 16.0, color: Colors.grey)),
                      Text("R\$ ${rideDetail["valor"]},00",
                          style: const TextStyle(
                              fontSize: 16.0, color: Colors.grey)),
                      const SizedBox(height: 18.0),
                      const Text("Tipo",
                          style: TextStyle(fontSize: 16.0, color: Colors.grey)),
                      user['id'] == rideDetail['motorista']['id_fk_user']
                          ? const Text("Motorista",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: darkBlueColor,
                                  fontWeight: FontWeight.bold))
                          : const Text("Passageiro",
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
                            final caronista =
                                "${rideDetail["passageiros"][index]["user"]["first_name"]} ${rideDetail["passageiros"][index]["user"]["first_name"]}";
                            return Text(caronista);
                          }),
                      const Text("motorista",
                          style: TextStyle(fontSize: 16.0, color: Colors.grey)),
                      Text(
                          "${rideDetail['motorista']['user']['first_name']} ${rideDetail['motorista']['user']['last_name']}"),
                      const SizedBox(height: 18.0),
                      user['id'] == rideDetail['motorista']['id_fk_user']
                          ? OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  width: 1.0,
                                  color: Color(0xFF00AFF8),
                                  style: BorderStyle.solid,
                                ),
                                backgroundColor:
                                    Color.fromARGB(255, 255, 255, 255),
                              ),
                              onPressed: () async {
                                int id = rideDetail["id"];
                                _showConfirmationDialog(
                                    context, id, rideDetail, 1, 'cancelar');
                                // authService.deleteCaronabyID(rideDetail["id"]);
                              },
                              child: const Text(
                                'Cancelar Corrida',
                                style: TextStyle(
                                    color: Color(0xFF00AFF8), fontSize: 16),
                              ),
                            )
                          : OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  width: 1.0,
                                  color: Color(0xFF00AFF8),
                                  style: BorderStyle.solid,
                                ),
                                backgroundColor:
                                    Color.fromARGB(255, 255, 255, 255),
                              ),
                              onPressed: () async {
                                // print('\nteste\n');
                                // print('rideDetail["passageiros"]["id"]');
                                // print(rideDetail["passageiros"]);
                                print('\n\nrideDetail["id"]');
                                print(rideDetail["id"]);
                                int id = rideDetail["id"];
                                _showConfirmationDialog(
                                    context, id, rideDetail, 2, 'sair');
                              },
                              child: const Text(
                                'Sair da Corrida',
                                style: TextStyle(
                                    color: Color(0xFF00AFF8), fontSize: 16),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
    );
  }

  Future<void> _showConfirmationDialog(
      BuildContext context, int id, var ride, int role, String word) async {
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
          content: 'Você tem certeza que deseja $word essa carona?',
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
                onPressed: () async {
                  if (role == 1) {
                    try {
                      authService.deleteCaronabyID(rideDetail["id"]);
                    } catch (error) {
                      print(error);
                    }
                  } else {
                    try {
                      authService.deletePassFromCarona(
                          user["id"], rideDetail["id"]);
                    } catch (error) {
                      print(error);
                    }
                  }
                  Navigator.of(context).pushNamed(
                    '/Historico',
                  );
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
}
