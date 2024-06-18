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
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  var _userLoading = true;
  var _rideLoading = true;
  var center;
  var _mapLoading = true;

  late GoogleMapController mapController;
  Set<Polyline> _polylines = Set<Polyline>();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _getPolyline();
  }

  Future<LatLng> _getCoordinates(String address) async {
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeFull(address)}&key=AIzaSyA0Q5HTFqw-wrHtQxbGgmq6cv8MC57jiUU';
    http.Response response = await http.get(Uri.parse(url));
    Map data = json.decode(response.body);

    if (data['status'] == 'OK') {
      double lat = data['results'][0]['geometry']['location']['lat'];
      double lng = data['results'][0]['geometry']['location']['lng'];
      return LatLng(lat, lng);
    } else {
      // Lança uma exceção se o status não for 'OK'
      throw Exception(
          "Failed to get coordinates for the address: $address. Status: ${data['status']}");
    }
  }

  void _getPolyline() async {
    // String url_origin =
    //     'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=AIzaSyA0Q5HTFqw-wrHtQxbGgmq6cv8MC57jiUU';
    // http.Response response = await http.get(Uri.parse(url));
    // Map data = json.decode(response.body);
    // if (data['status'] == 'OK') {
    //   double lat = data['results'][0]['geometry']['location']['lat'];
    //   double lng = data['results'][0]['geometry']['location']['lng'];
    // }

    LatLng origin = await _getCoordinates("${rideDetail['local_partida']}");
    print('rideDetail: ${rideDetail['local_partida']}');
    // print('\n Origin destination\n\n\n');
    print('origin: $origin');
    center = origin;

    // print('rideDetail: ${rideDetail['local_destino']}');
    LatLng destination =
        await _getCoordinates("${rideDetail['local_destino']}");
    print('destination: $destination');

    // LatLng origin = LatLng(-22.906127, -43.094344);
    // LatLng destination = LatLng(-22.844626, -43.075444);
    // LatLng origin = LatLng(-23.563987, -46.653492);
    // LatLng destination = LatLng(-22.906846, -43.172896);

    print('Cneter wndawdiuawhduawhdhwhdiuahuw $center');

    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=AIzaSyA0Q5HTFqw-wrHtQxbGgmq6cv8MC57jiUU';
    http.Response response = await http.get(Uri.parse(url));
    Map data = json.decode(response.body);
    var points = data['routes'][0]['overview_polyline']['points'];
    List<LatLng> polylineCoordinates = _convertToLatLng(_decodePoly(points));
    setState(() {
      center = origin;
      _mapLoading = false;
    });
    if (data['status'] == 'OK') {
      var points = data['routes'][0]['overview_polyline']['points'];
      List<LatLng> polylineCoordinates = _convertToLatLng(_decodePoly(points));

      setState(() {
        _polylines.add(
          Polyline(
            polylineId: PolylineId('route'),
            visible: true,
            points: polylineCoordinates,
            width: 4,
            color: Colors.blue,
          ),
        );
      });
    } else {
      print('Erro ao carregar rota: ${data['status']}');
      setState(() {
        _mapLoading = false; // Atualiza o estado mesmo em caso de erro
      });
    }

    setState(() {
      _mapLoading = false; // Atualiza o estado mesmo em caso de erro
    });
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = [];
    int index = 0;
    int len = poly.length;
    int c = 0;
    do {
      var shift = 0;
      int result = 0;

      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << shift;
        index++;
        shift += 5;
      } while (c >= 32);
      if (result & 1 != 0) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    return lList;
  }

  ////////////////////////////////////////////////////
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
      setState(() {
        _userLoading = false;
      });
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
        _rideLoading = false;
      });
      _getPolyline();
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime dataPartida = DateTime.parse(rideDetail['hora_partida']);
    DateTime agora = DateTime.now();
    String priceLayout =
        'R\$ ${rideDetail['valor'].toStringAsFixed(2).replaceAll(".", ",")}';

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
      body: _userLoading || _rideLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(
                              top: 20.0, left: 20.0, right: 20.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: clearBlueColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color: Colors.white,
                          ),
                          height: 200, // Altura do mapa
                          width: 300, // Largura do mapa
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            child: center == null
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : GoogleMap(
                                    onMapCreated: _onMapCreated,
                                    initialCameraPosition: CameraPosition(
                                      target: center,
                                      zoom: 12,
                                    ),
                                    polylines: _polylines,
                                  ),
                          )),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      rideDetail["local_partida"],
                                      rideDetail["local_destino"],
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
                                                    color: darkBlueColor,
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
                            Text("$priceLayout",
                                style: const TextStyle(
                                    fontSize: 16.0, color: Colors.grey)),
                            const SizedBox(height: 18.0),
                            const Text("Tipo",
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.grey)),
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
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.grey)),
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
                                            rideDetail['motorista']
                                                ['id_fk_user']
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
                                                        .isAfter(
                                                            DateTime.now()))
                                                    ? OutlinedButton(
                                                        style: OutlinedButton
                                                            .styleFrom(
                                                          side:
                                                              const BorderSide(
                                                            width: 1.0,
                                                            color:
                                                                clearBlueColor,
                                                            style: BorderStyle
                                                                .solid,
                                                          ),
                                                          backgroundColor:
                                                              clearBlueColor,
                                                        ),
                                                        onPressed: () async {
                                                          int id = rideDetail[
                                                                  'motorista']
                                                              ['id_fk_user'];
                                                          print(
                                                              "TAUAUAUAAUAUUAUAUAUAUAUAUAU $id");
                                                          _showRatingDialog(
                                                              context, id, 1);
                                                        },
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
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.grey)),
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
                                      final firstName =
                                          rideDetail["passageiros"][index]
                                              ["user"]["first_name"];
                                      final lastName = rideDetail["passageiros"]
                                          [index]["user"]["last_name"];
                                      final rate = rideDetail["passageiros"]
                                          [index]["nota_passageiro"]?? "";
                                      final caronista = "$firstName $lastName";

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
                                                    Text(softWrap: true,
                                                        "Eu ($caronista) $rate"),
                                                  ])
                                            : Column(children: [
                                                Text(softWrap: true, "$caronista $rate"),
                                                (!DateTime.parse(rideDetail[
                                                            "hora_partida"])
                                                        .isAfter(
                                                            DateTime.now()))
                                                    ? OutlinedButton(
                                                        style: OutlinedButton
                                                            .styleFrom(
                                                          side:
                                                              const BorderSide(
                                                            width: 1.0,
                                                            color:
                                                                clearBlueColor,
                                                            style: BorderStyle
                                                                .solid,
                                                          ),
                                                          backgroundColor:
                                                              clearBlueColor,
                                                        ),
                                                        onPressed: () async {
                                                          int id = rideDetail[
                                                                  "passageiros"]
                                                              [
                                                              index]["user"]["id"];

                                                          _showRatingDialog(
                                                              context, id, 2);
                                                        },
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
                            const SizedBox(height: 12.0),
                            ElevatedButton.icon(
                              icon: const FaIcon(FontAwesomeIcons.exclamation,
                                  color: Colors.white),
                              label: Text(
                                user['id'] ==
                                        rideDetail['motorista']['id_fk_user']
                                    ? 'Deletar carona'
                                    : 'sair da carona',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () async {
                                if (user['id'] ==
                                    rideDetail['motorista']['id_fk_user']) {
                                  _showConfirmationDialog(
                                      context,
                                      rideDetail['id'],
                                      rideDetail,
                                      1,
                                      "deletar essa carona");
                                } else {
                                  _showConfirmationDialog(
                                      context,
                                      rideDetail['id'],
                                      rideDetail,
                                      0,
                                      "sair dessa carona");
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
          content: 'Você tem certeza que deseja ${word}?',
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

  Future<void> _showRatingDialog(BuildContext context, int id, int role) async {
    double rating = 0; // Inicialize a variável de avaliação

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Avalie o Usuario',
            style: TextStyle(
                color: darkBlueColor,
                fontSize: 20,
                fontWeight: FontWeight.w800),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Por favor, avalie sua experiência com esse usuario durante a viagem:',
                  style: TextStyle(
                      color: Color(0xFF00AFF8),
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) =>
                      Icon(Icons.star, color: darkBlueColor),
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
                if (role == 1) {
                  authService.postRatingMotorista(
                      rideDetail["id"], 4, rating, "teste");
                  Navigator.of(context).pop(); // Fecha o diálogo
                  print('Avaliação recebida: $rating');
                } else {
                  authService.postRatingCaronista(
                      rideDetail["id"], id, rating, "comentarioPassageiro");
                }
                Navigator.of(context).pop();
              },
              child: const Text('Enviar Avaliação'),
            ),
          ],
        );
      },
    );
  }
}
