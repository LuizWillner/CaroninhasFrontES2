import 'package:flutter/material.dart';
import 'package:app_uff_caronas/components/bottom_bar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_uff_caronas/services/service_auth_and_user.dart';
import 'package:app_uff_caronas/services/api_services.dart';

class AdicionarCarro extends StatefulWidget {
  const AdicionarCarro({super.key});

  @override
  State<AdicionarCarro> createState() => _AdicionarCarroState();
}

class _AdicionarCarroState extends State<AdicionarCarro> {
  static const clearBlueColor = Color(0xFF00AFF8);
  static const darkBlueColor = Color(0xFF0E4B7C);
  String? _selectedMarca;
  String? _selectedCor;
  List<String> _marcas = ["AUDI", "FORD", "FIAT"];
  List<String> _cores = ["BRANCO, PRETO"];
  TextEditingController _cnhController = TextEditingController();
  // TextEditingController _marcaController = TextEditingController();
  TextEditingController _modeloController = TextEditingController();
  TextEditingController _corController = TextEditingController();
  TextEditingController _placaController = TextEditingController();
  final AuthService authService = AuthService(apiService: ApiService());
  final storage = const FlutterSecureStorage();
  var _loading = true;
  dynamic user;

  void _fetchUserData() async {
    try {
      user = await authService.getUser();
      Map<String, dynamic> responseMarcas =
          await ApiService().getApi('veiculo/marcas');
      Map<String, dynamic> responseCores =
          await ApiService().getApi('veiculo/cores');
      List<String> marcas = List<String>.from(responseMarcas['data']);
      List<String> cores = List<String>.from(responseCores['data']);
      setState(() {
        _marcas = marcas;
        _cores = cores;
      });
      // _fetchDriverData();
    } catch (error) {
      print(error.toString());
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Adicionar Carro', // trocar para nome da pessoa qnd for perfil de outro user
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
                child: SizedBox(
                    child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                              child: TextField(
                                controller: _cnhController,
                                decoration: const InputDecoration(
                                  labelText: 'CNH',
                                  labelStyle:
                                      TextStyle(color: Color(0xFF0E4B7C)),
                                  border: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF0E4B7C)),
                                  ),
                                  prefixIcon: Icon(Icons.car_repair,
                                      color: Color(0xFF0E4B7C)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                              child: DropdownButtonFormField<String>(
                                value: _selectedMarca,
                                decoration: const InputDecoration(
                                  labelText: 'Marca',
                                  labelStyle:
                                      TextStyle(color: Color(0xFF0E4B7C)),
                                  border: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF0E4B7C)),
                                  ),
                                  prefixIcon: Icon(Icons.car_repair,
                                      color: Color(0xFF0E4B7C)),
                                ),
                                items: _marcas.map((String marca) {
                                  return DropdownMenuItem<String>(
                                    value: marca,
                                    child: Text(marca),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedMarca = newValue;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                              child: TextField(
                                controller: _modeloController,
                                decoration: const InputDecoration(
                                  labelText: 'Modelo',
                                  labelStyle:
                                      TextStyle(color: Color(0xFF0E4B7C)),
                                  border: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF0E4B7C)),
                                  ),
                                  prefixIcon: Icon(Icons.car_repair,
                                      color: Color(0xFF0E4B7C)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                              child: DropdownButtonFormField<String>(
                                value: _selectedCor,
                                decoration: const InputDecoration(
                                  labelText: 'Cor',
                                  labelStyle:
                                      TextStyle(color: Color(0xFF0E4B7C)),
                                  border: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF0E4B7C)),
                                  ),
                                  prefixIcon: Icon(Icons.car_repair,
                                      color: Color(0xFF0E4B7C)),
                                ),
                                items: _cores.map((String cor) {
                                  return DropdownMenuItem<String>(
                                    value: cor,
                                    child: Text(cor),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedCor = newValue;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                              child: TextField(
                                controller: _placaController,
                                decoration: const InputDecoration(
                                  labelText: 'Placa',
                                  labelStyle:
                                      TextStyle(color: Color(0xFF0E4B7C)),
                                  border: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFF0E4B7C)),
                                  ),
                                  prefixIcon: Icon(Icons.numbers,
                                      color: Color(0xFF0E4B7C)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  width: 1.0,
                                  color: Color(0xFF00AFF8),
                                  style: BorderStyle.solid,
                                ),
                                backgroundColor: const Color(0xFF00AFF8),
                              ),
                              onPressed: () async {
                                print(await storage.read(key: 'login_token'));
                                final marca = _selectedMarca;
                                final modelo = _modeloController.text;
                                final cor = _selectedCor;
                                final placa = _placaController.text;
                                final cnh = _cnhController.text;

                                try {
                                  final userStatus =
                                      await authService.becomeMotorist(cnh);
                                  print(userStatus);
                                  await storage.write(
                                      key: "isDriver", value: "true");
                                } catch (error) {
                                  print(error);
                                }

                                try {
                                  final car = await authService.createCar(
                                      marca!, modelo, cor!, placa);
                                  print(car);
                                  Navigator.of(context).pushNamed(
                                    '/Perfil',
                                  );
                                } catch (error) {
                                  print(error);
                                }
                              },
                              child: const Text(
                                'Adicionar',
                                style: TextStyle(
                                    color: Color(0xFFFAFAFA), fontSize: 24),
                              ),
                            ),
                          ],
                        )))),
        bottomNavigationBar: CustomBottomNavigationBar(currentIndex: 3));
  }
}
