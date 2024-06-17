import 'package:flutter/material.dart';
import 'package:app_uff_caronas/components/bottom_bar.dart';
import 'package:app_uff_caronas/components/path_details.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_uff_caronas/services/service_auth_and_user.dart';
import 'package:app_uff_caronas/services/api_services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_uff_caronas/components/custom_alert.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
    DateTime dataPartida = DateTime.parse(rideDetail['hora_partida']);
    DateTime agora = DateTime.now();

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
                      (!DateTime.parse(rideDetail["hora_partida"])
                              .isAfter(DateTime.now()))
                          ? TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 255, 255, 255),
                              ),
                              onPressed: () async {},
                              child: const Text(
                                'Corrida Concluida',
                                style: TextStyle(
                                    color: Color(0xFF00AFF8),
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : Text(""),
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
                      const SizedBox(height: 20.0),
                      const Text("Motorista",
                          style: TextStyle(fontSize: 16.0, color: Colors.grey)),
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 50.0,
                            child: ClipOval(
                                child: Image.network(
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0sCAvrW1yFi0UYMgTZb113I0SwtW0dpby8Q&usqp=CAU')),
                          ),
                          const SizedBox(width: 18.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              user['id'] ==
                                      rideDetail['motorista']['id_fk_user']
                                  ? Column(children: [
                                      Text(
                                          "Eu (${rideDetail['motorista']['user']['first_name']} ${rideDetail['motorista']['user']['last_name']})")
                                    ])
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                          Text(
                                            "${rideDetail['motorista']['user']['first_name']} ${rideDetail['motorista']['user']['last_name']}",
                                          ),
                                          (!DateTime.parse(rideDetail[
                                                      "hora_partida"])
                                                  .isAfter(DateTime.now()))
                                              ? OutlinedButton(
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    side: const BorderSide(
                                                      width: 1.0,
                                                      color: clearBlueColor,
                                                      style: BorderStyle.solid,
                                                    ),
                                                    backgroundColor:
                                                        clearBlueColor,
                                                  ),
                                                  onPressed: () async {},
                                                  child: const Text(
                                                    'Avalie Motorista',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                )
                                              : Text(""),
                                        ]),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      const Text("Passageiros",
                          style: TextStyle(fontSize: 16.0, color: Colors.grey)),
                      const SizedBox(height: 10.0),
                      rideDetail["passageiros"].isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Nenhum passageiro cadastrado nessa viagem",
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: rideDetail["passageiros"].length,
                              itemBuilder: (context, index) {
                                final firstName = rideDetail["passageiros"]
                                    [index]["user"]["first_name"];
                                final LastName = rideDetail["passageiros"]
                                    [index]["user"]["last_name"];
                                final rate = rideDetail["passageiros"][index]
                                    ["nota_passageiro"];
                                final caronista = "$firstName $LastName";

                                return Row(children: [
                                  CircleAvatar(
                                    radius: 50.0,
                                    child: ClipOval(
                                        child: Image.network(
                                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0sCAvrW1yFi0UYMgTZb113I0SwtW0dpby8Q&usqp=CAU')),
                                  ),
                                  const SizedBox(width: 18.0),
                                  user["iduff"] ==
                                          rideDetail['passageiros'][index]
                                              ["user"]["iduff"]
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                              Text("Eu ($caronista) $rate"),
                                            ])
                                      : Column(children: [
                                          Text("$caronista $rate"),
                                          (!DateTime.parse(rideDetail[
                                                      "hora_partida"])
                                                  .isAfter(DateTime.now()))
                                              ? OutlinedButton(
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    side: const BorderSide(
                                                      width: 1.0,
                                                      color: clearBlueColor,
                                                      style: BorderStyle.solid,
                                                    ),
                                                    backgroundColor:
                                                        clearBlueColor,
                                                  ),
                                                  onPressed: () async {},
                                                  child: const Text(
                                                    'Avalie o Passageiro',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                )
                                              : Text(""),
                                        ]),
                                ]);
                              }),
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

  Future<void> _showRatingDialog(BuildContext context) async {
    double rating = 0; // Inicialize a variável de avaliação

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Avalie a Carona'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Por favor, avalie sua experiência com a viagem:'),
                RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) =>
                      Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (newRating) {
                    rating = newRating; // Atualize a avaliação
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
                print('Avaliação recebida: $rating');
                // Aqui você pode salvar a avaliação no banco de dados ou realizar outra ação
              },
              child: const Text('Enviar Avaliação'),
            ),
          ],
        );
      },
    );
  }
}
