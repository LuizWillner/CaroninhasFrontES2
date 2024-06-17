import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

const Color clearBlueColor = Color(0xFF00AFF8);
const Color darkBlueColor = Color(0xFF0E4B7C);

class Viagem extends StatelessWidget {
  final String image;
  final String partida;
  final String chegada;
  final String nome;
  final DateTime data;
  final VoidCallback onPressed;
  final double price;
  final int vagasRestantes;
  final String buttonInnerText;

  const Viagem(
      {required this.image,
      required this.partida,
      required this.chegada,
      required this.nome,
      required this.data,
      required this.onPressed,
      required this.price,
      required this.vagasRestantes,
      required this.buttonInnerText});

  @override
  Widget build(BuildContext context) {
    String dataLayout = DateFormat('dd/MM/yyyy').format(data);
    String horaLayout = DateFormat('HH:mm').format(data);
    String priceLayout = 'R\$ ${price.toStringAsFixed(2).replaceAll(".", ",")}';

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: clearBlueColor,
          width: 1.0,
        ),
      ),
      height: 210,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 8),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "De: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: partida,
                          ),
                          const TextSpan(
                            text: "\nPara: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: chegada,
                          ),
                        ],
                      ),
                      style:
                          const TextStyle(fontSize: 16, color: darkBlueColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    Text(
                      dataLayout,
                      style:
                          const TextStyle(fontSize: 14, color: darkBlueColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      horaLayout,
                      style:
                          const TextStyle(fontSize: 14, color: darkBlueColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      "Motorista: $nome",
                      style:
                          const TextStyle(fontSize: 14, color: darkBlueColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
              child: Row(
                children: [
                  Text(
                    priceLayout,
                    style: const TextStyle(fontSize: 14, color: darkBlueColor),
                  ),
                  const Spacer(),
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
                    child: Text(
                      buttonInnerText,
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              )),
          const Spacer()
        ],
      ),
    );
  }
}
