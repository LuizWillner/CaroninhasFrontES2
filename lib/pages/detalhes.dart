import 'package:flutter/material.dart';
import 'package:app_uff_caronas/components/bottom_bar.dart';
import 'package:app_uff_caronas/components/path_details.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_uff_caronas/services/service_auth_and_user.dart';
import 'package:app_uff_caronas/services/api_services.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
                            final firstName = rideDetail["passageiros"][index]["user"]
                                ["first_name"];
                            final LastName = rideDetail["passageiros"][index]["user"]
                                ["last_name"];
                            final rate = rideDetail["passageiros"][index]["nota_passageiro"];
                            final caronista =
                                "$firstName $LastName - $rate";
                            return Text(caronista);
                          }),
                      const Text("motorista",
                          style: TextStyle(fontSize: 16.0, color: Colors.grey)),
                      Text(
                          "${rideDetail['motorista']['user']['first_name']} ${rideDetail['motorista']['user']['last_name']}"),
                      const SizedBox(height: 18.0),
                      ElevatedButton.icon(
                        icon: const FaIcon(FontAwesomeIcons.whatsapp,
                            color: Colors.white),
                        label: const Text(
                          'Enviar mensagem',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: clearBlueColor,
                        ),
                        onPressed: () async {
                          String url =
                              "https://wa.me/+${rideDetail['motorista']['user']['phone']}/?text=Queria conversar sobre a viagem do dia ${DateFormat("yyyy-MM-ddTHH:mm:ss").parse(rideDetail["hora_partida"]).day}/"
                              "${DateFormat("yyyy-MM-ddTHH:mm:ss").parse(rideDetail["hora_partida"]).month} ${DateFormat("yyyy-MM-ddTHH:mm:ss").parse(rideDetail["hora_partida"]).hour}:"
                              "${DateFormat("yyyy-MM-ddTHH:mm:ss").parse(rideDetail["hora_partida"]).minute}";
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                      )
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
}
