import 'package:app_uff_caronas/pages/home.dart';
import 'package:app_uff_caronas/pages/login.dart';
import 'package:app_uff_caronas/pages/cadastro.dart';
import 'package:app_uff_caronas/pages/test.dart';
import 'package:app_uff_caronas/pages/perfil.dart';
import 'package:app_uff_caronas/pages/oferecer_carona.dart';
import 'package:app_uff_caronas/pages/detalhes.dart';
import 'package:app_uff_caronas/pages/pedir_carona.dart';
import 'package:app_uff_caronas/pages/pedindo_carona.dart';
import 'package:app_uff_caronas/pages/adicionarCarro.dart';
import 'package:app_uff_caronas/pages/historico_caronas.dart';
import 'package:app_uff_caronas/pages/historico.dart';
import 'package:app_uff_caronas/pages/alterarDados.dart';
import 'package:app_uff_caronas/pages/avaliacao.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/Home':
        return MaterialPageRoute(builder: ((context) => const Home()));
      case '/Login':
        return MaterialPageRoute(builder: ((context) => const Login()));
      case '/Cadastro':
        return MaterialPageRoute(builder: ((context) => const Cadastro()));
      case '/Test':
        return MaterialPageRoute(builder: ((context) => const Test()));
      case '/Perfil':
        return MaterialPageRoute(builder: ((context) => const Perfil()));
      case '/Criar_carona':
        return MaterialPageRoute(builder: ((context) => const CriarCarona()));
      case '/Detalhes_carona':
        if (args is String) {
          return MaterialPageRoute(
              builder: (context) => DetalhesCarona(caronaId: args));
        }
        return MaterialPageRoute(
            builder: ((context) => const Text("algo deu errado")));
      case '/Historico_carona':
        return MaterialPageRoute(
            builder: ((context) => const HistoricoCarona()));
      case '/Pedir_carona':
        return MaterialPageRoute(builder: ((context) => const PedirCarona()));
      case '/Pedindo_carona':
        return MaterialPageRoute(builder: ((context) => const PedindoCarona()));
      case '/Adicionar_carro':
        return MaterialPageRoute(
            builder: ((context) => const AdicionarCarro()));
      case '/Historico':
        return MaterialPageRoute(builder: ((context) => const Historico()));
      case '/Avaliacao':
        if (args is String) {
          return MaterialPageRoute(
              builder: (context) => Avaliacao(caronaId: args));
        }
        return MaterialPageRoute(
            builder: ((context) => const Text("algo deu errado")));
      case '/Alterar_dados':
        return MaterialPageRoute(builder: ((context) => const AlterarDados()));
      default:
        return MaterialPageRoute(builder: ((context) => const Home()));
    }
  }
}
