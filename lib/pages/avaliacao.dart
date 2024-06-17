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

class Avaliacao extends StatefulWidget {
  final String caronaId;
  const Avaliacao({super.key, required this.caronaId});

  @override
  State<Avaliacao> createState() => _AvaliacaoState();
}

class _AvaliacaoState extends State<Avaliacao> {
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
          'Avaliação',
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
              children: [Text("Passageiros")],
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
