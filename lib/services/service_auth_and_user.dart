import 'package:app_uff_caronas/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AuthService {
  final ApiService apiService;

  AuthService({required this.apiService});

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await apiService
        .postUrlencoded('token', {'username': username, 'password': password});
    return response;
  }

//TODO data
  Future<Map<String, dynamic>> createUser(
      String email,
      String firstName,
      String lastName,
      String cpf,
      String birthdate,
      String iduff,
      String phone,
      String password) async {
    final response = await apiService.postApi('users/create', {
      "email": email,
      "first_name": firstName,
      "last_name": lastName,
      "cpf": cpf,
      "birthdate": "2000-05-20T04:48:56.242Z",
      "phone": phone,
      "iduff": iduff,
      "password": password
    });
    return response;
  }

  Future<Map<String, dynamic>> createCar(
    String marca,
    String modelo,
    String cor,
    String placa,
  ) async {
    final response = await apiService.postApi(
        'veiculo/me?tipo=CARRO&marca=$marca&modelo=$modelo&cor=$cor&placa=$placa',
        {});
    return response;
  }

  Future<Map<String, dynamic>> createRide(
      int? veiculoId,
      DateTime horaDePartida,
      String precoCarona,
      String vagas,
      String localPartida,
      String localDestino) async {
    final stringHoraDePartida = horaDePartida.toString().replaceAll(":", "%3A");
    final response = await apiService.postApi(
        'carona?veiculo_id=$veiculoId&hora_de_partida=$stringHoraDePartida&preco_carona=$precoCarona&vagas=$vagas',
        {"local_partida": localPartida, "local_destino": localDestino});
    return response;
  }

  Future<Map<String, dynamic>> becomeMotorist(
    String cnh,
  ) async {
    final response =
        await apiService.postApi("users/me/motorista?num_cnh=$cnh", {});
    return response;
  }

  Future<Map<String, dynamic>> getUser() async {
    final response = await apiService.getApi("users/me");
    return response;
  }
  
  Future<Map<String, dynamic>> getAllRides() async {
    final response = await apiService.getApi("carona");
    return response;
  }

  Future<Map<String, dynamic>> getAllCars() async {
    final response = await apiService.getApi("veiculo/me/all");
    return response;
  }

////////////////////////////////////////////////////////////
  Future<Map<String, dynamic>> getRides({
    String? motoristaId,
    DateTime? horaMinima,
    DateTime? horaMaxima,
    int valorMinimo = 0,
    int valorMaximo = 9999,
    int vagasRestantesMinimas = 1,
    String keywordPartida = "",
    String keywordChegada = "",
    String orderBy = "hora da partida",
    bool isCrescente = true,
    int limite = 25,
    int deslocamento = 0,
  }) async {
    horaMinima ??= DateTime.now();
    horaMaxima ??= DateTime.now().add(const Duration(days: 30));
    var motoristaQuery = "motorista_id=$motoristaId&";
    if (motoristaId == null) {
      motoristaQuery = "";
    }
    final response = await apiService.getApi("carona?$motoristaQuery"
        "hora_minima=$horaMinima"
        "&hora_maxima=$horaMaxima"
        "&valor_minimo=$valorMinimo"
        "&valor_maximo=$valorMaximo"
        "&vagas_restantes_minimas=$vagasRestantesMinimas"
        "&keyword_partida=$keywordPartida"
        "&keyword_chegada=$keywordChegada"
        "&order_by=$orderBy"
        "&is_crescente=$isCrescente"
        "&limite=$limite"
        "&deslocamento=$deslocamento");
    return response;
  }


  Future<Map<String, dynamic>> getRatingCaronista(idCaronista) async {
    final response = await apiService.getApi("avaliacao/passageiro/$idCaronista");
    return response;
  }

  Future<Map<String, dynamic>> getRatingMotorista(idMotorista) async {
    final response = await apiService.getApi("avaliacao/motorista/$idMotorista");
    return response;
  }

  Future<Map<String, dynamic>> postRatingCaronista(caronaId,userAvaliadoId, notaPassageiro, comentarioPassageiro) async {
    final response = await apiService.postApi("avaliacao/passageiro?carona_id=$caronaId&user_avaliado_id=$userAvaliadoId", {
      "nota_passageiro":notaPassageiro,
      "comentario_passageiro":comentarioPassageiro
    });
    return response;
  }

  Future<Map<String, dynamic>> postRatingMotorista(caronaId,userAvaliadoId, notaMotorista, comentarioMotorista) async {
    final response = await apiService.postApi("avaliacao/passageiro?carona_id=$caronaId&user_avaliado_id=$userAvaliadoId",{
      "nota_motorista":notaMotorista,
      "comentario_motorista":comentarioMotorista
    });
    return response;
  }
}
