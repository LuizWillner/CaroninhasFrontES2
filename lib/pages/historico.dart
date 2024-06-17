// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:app_uff_caronas/components/bottom_bar.dart';
import 'package:app_uff_caronas/components/cadastro_input.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_uff_caronas/services/service_auth_and_user.dart';
import 'package:app_uff_caronas/services/api_services.dart';
import 'package:app_uff_caronas/components/custom_alert.dart';
import 'package:app_uff_caronas/components/viagem.dart';
import 'package:intl/intl.dart';

class Historico extends StatefulWidget {
  const Historico({super.key});

  @override
  State<Historico> createState() => _HistoricoState();
}

class _HistoricoState extends State<Historico>
    with SingleTickerProviderStateMixin {
  static const clearBlueColor = Color(0xFF00AFF8);
  static const darkBlueColor = Color(0xFF0E4B7C);
  final storage = const FlutterSecureStorage();
  final AuthService authService = AuthService(apiService: ApiService());
  var _loading = true;
  dynamic user;
  var _historico = [];

  late TabController _tabController;

  Future _fetchUserData() async {
    try {
      final isDriver = await storage.read(key: "isDriver");
      final passagerResponse = await authService.getHistoricoCaronista();
      // print('object tutu \n');
      // print(passagerResponse.runtimeType);
      // print('Driver = $isDriver');
      if (isDriver == "true") {
        final driverResponse = await authService.getHistoricoMotorista();
        List<dynamic> historico_somado =
            passagerResponse['data'] + driverResponse['data'];
        setState(() {
          _historico = historico_somado;
          _loading = false;
        });
      } else {
        setState(() {
          _historico = passagerResponse['data'];
          print('O historico é driver: $_historico');
          _loading = false;
        });
      }
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() => _fetchUserData());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Suas Viagens',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const BackButton(color: Colors.white),
        backgroundColor: clearBlueColor,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Center(
                    child: Text(
                      "Dê uma caroninha!",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: darkBlueColor,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: clearBlueColor),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: clearBlueColor,
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      Container(
                        alignment: Alignment.center,
                        child: const Tab(
                          child: Text('Corridas Atuais'),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: const Tab(
                          child: Text('Histórico'),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: clearBlueColor),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildHistoricoList(true, _historico),
                        _buildHistoricoList(false, _historico)
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 2),
    );
  }

  Widget _buildHistoricoList(current, historico) {
    if (current) {
      List<dynamic> historicoAtual = [];
      for (int i = 0; i < historico.length; i++) {
        if (!DateTime.parse(historico[i]["hora_partida"])
            .isBefore(DateTime.now())) {
          historicoAtual.add(historico[i]);
        }
      }
      historico = historicoAtual;
    } else {
      List<dynamic> historicoAtual = [];
      for (int i = 0; i < historico.length; i++) {
        if (!DateTime.parse(historico[i]["hora_partida"])
            .isAfter(DateTime.now())) {
          historicoAtual.add(historico[i]);
        }
      }
      historico = historicoAtual;
    }
    print(current);
    return ListView.builder(
      itemCount: historico.length,
      itemBuilder: (context, index) {
        final ride = historico[index];
        return Viagem(
          image: "assets/login_background.png",
          partida: ride["local_partida"],
          chegada: ride["local_destino"],
          nome: ride["motorista"]["user"]["first_name"] +
              " " +
              ride["motorista"]["user"]["last_name"],
          data: DateFormat("yyyy-MM-ddTHH:mm:ss").parse(ride["hora_partida"]),
          onPressed: () {
            try {
              Navigator.pushNamed(
                context,
                '/Detalhes_carona',
                arguments: ride["id"].toString(),
              );
            } catch (error) {
              print(error);
            }
          },
          price: ride["valor"],
          vagasRestantes: ride["vagas_restantes"],
          buttonInnerText: "Ver detalhes",
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
