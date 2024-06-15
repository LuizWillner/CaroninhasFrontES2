import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const Color clearBlueColor = Color(0xFF00AFF8);
const Color darkBlueColor = Color(0xFF0E4B7C);

class Viagem extends StatelessWidget {
  final String image;
  final String partida;
  final String chegada;
  final String nome;
  final DateTime data;
  final VoidCallback onPressed;
  final int? price;

  Viagem(
      {required this.image,
      required this.partida,
      required this.chegada,
      required this.nome,
      required this.data,
      required this.onPressed,
      required this.price});

  @override
  Widget build(BuildContext context) {
    String dataLayout = '${data.day}/${data.month}';
    String horaLayout = '${data.hour}:${data.minute}';
    String priceLayout = 'R\$ ${price},00';

    return Container(
      height: 180,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 15),
                  Column(
                    children: [
                      Text("partida: $partida"),
                      Text("chegada: $chegada"),
                      Text(dataLayout),
                      Text(horaLayout),
                      Text("Nome do motorista $nome"),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text(priceLayout),
                  Spacer(),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        width: 1.0,
                        color: clearBlueColor,
                        style: BorderStyle.solid,
                      ),
                      backgroundColor: clearBlueColor,
                    ),
                    onPressed: onPressed,
                    child: const Text(
                      'Aceitar',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
