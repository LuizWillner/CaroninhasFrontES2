import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:app_uff_caronas/components/bottom_bar.dart';
import 'package:app_uff_caronas/components/path_details.dart';
import 'package:app_uff_caronas/services/service_auth_and_user.dart';
import 'package:app_uff_caronas/services/api_services.dart';
import 'package:app_uff_caronas/components/viagem.dart';
import 'package:intl/intl.dart';

class HistoricoCarona extends StatefulWidget {
  const HistoricoCarona({Key? key}) : super(key: key);

  @override
  State<HistoricoCarona> createState() => _HistoricoCaronaState();
}

class _HistoricoCaronaState extends State<HistoricoCarona>
    with SingleTickerProviderStateMixin {
  static const clearBlueColor = Color(0xFF00AFF8);
  static const darkBlueColor = Color(0xFF0E4B7C);
  final AuthService authService = AuthService(apiService: ApiService());
  var _loading = true;
  dynamic user;
  var _historico = [];

  late TabController _tabController;

  void _fetchUserData() async {
    try {
      user = await authService.getUser();
      if (user['motorista'] != null) {
        Map<String, dynamic> driver_response =
            await ApiService().getApi('/carona/historico/me/motorista');
        Map<String, dynamic> passager_response =
            await ApiService().getApi('/carona/historico/me/passageiro');
        List<String> historico_somado = List<String>.from(
            passager_response['data'] + driver_response['data']);
        setState(() {
          _historico = historico_somado;
          _loading = false;
          print(_historico);
        });
        // _fetchDriverData();
      } else {
        setState(() {
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
    _fetchUserData();
    _tabController = TabController(length: 2, vsync: this);
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
            'Viagens',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: const BackButton(color: Colors.white),
          backgroundColor: clearBlueColor,
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      itemCount: _historico.length,
                      itemBuilder: (context, index) {
                        final ride = _historico[index];
                        return Viagem(
                          image: "assets/login_background.png",
                          partida: ride["local_partida"],
                          chegada: ride["local_destino"],
                          nome: ride["motorista"]["user"]["first_name"] +
                              ride["motorista"]["user"]["last_name"],
                          data: DateFormat("yyyy-MM-ddTHH:mm:ss")
                              .parse(ride["hora_partida"]),
                          onPressed: () {
                            try {
                              Navigator.pushNamed(
                                context,
                                '/Detalhes_carona',
                                arguments: ride["id"],
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
                    ),
                    Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.03,
                            left: 30.0,
                            right: 30.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: clearBlueColor,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color: Colors.white),
                        child: TabBar(
                          controller: _tabController,
                          tabs: const [
                            Tab(child: Text('Caronas programadas')),
                            Tab(child: Text('Caronas anteriores'))
                          ],
                        )),
                    Container(
                        height: 500,
                        margin: const EdgeInsets.only(left: 30.0, right: 30.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: clearBlueColor,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color: Colors.white),
                        padding: const EdgeInsets.only(top: 20.0),
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Text("caronas novas"),
                            // Column(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   crossAxisAlignment: CrossAxisAlignment.stretch,
                            //   children: [
                            //     const SizedBox(height: 16.0),
                            //     Padding(
                            //       padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                            //       child: OutlinedButton(
                            //         style: OutlinedButton.styleFrom(
                            //           side: const BorderSide(
                            //             width: 1.0,
                            //             color: clearBlueColor,
                            //             style: BorderStyle.solid,
                            //           ),
                            //           backgroundColor: clearBlueColor,
                            //         ),
                            //         onPressed: () => {
                            //           Navigator.of(context)
                            //               .pushNamed('/Pedindo_carona')
                            //         },
                            //         child: const Text(
                            //           'Procurar',
                            //           style: TextStyle(
                            //               color: Colors.white, fontSize: 24),
                            //         ),
                            //       ),
                            //     ),
                            //     const SizedBox(height: 18.0),
                            //   ],
                            // ),
                            Text("caronas antigas")
                          ],
                        ))
                  ],
                ),
              ),
        bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 2));
  }
}
