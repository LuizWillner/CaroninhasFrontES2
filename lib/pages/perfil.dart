import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:app_uff_caronas/components/bottom_bar.dart';

class Perfil extends StatefulWidget {
  const Perfil({Key? key}) : super(key: key);

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  static const clearBlueColor = Color(0xFF00AFF8);
  static const darkBlueColor = Color(0xFF0E4B7C);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meu perfil', // trocar para nome da pessoa qnd for perfil de outro user
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const BackButton(color: Colors.white),
        backgroundColor: clearBlueColor,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 80.0,
                                child: ClipOval(
                                    child: Image.network(
                                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0sCAvrW1yFi0UYMgTZb113I0SwtW0dpby8Q&usqp=CAU')),
                              ),
                              const Text("Alterar imagem", style: TextStyle(
                                color: darkBlueColor
                              ),)
                            ],
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          const Column(
                            // tirar const
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nome',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: darkBlueColor,
                                    height: 0.5),
                              ),
                              Text(
                                'John Doe',
                                style: TextStyle(
                                    fontSize: 24.0,
                                    color: darkBlueColor,
                                    fontWeight: FontWeight.bold,
                                    height: 1.0),
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                'Rating',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: darkBlueColor,
                                    height: 0.5),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                '4.8 ⭐',
                                style: TextStyle(
                                    fontSize: 24.0,
                                    color: darkBlueColor,
                                    fontWeight: FontWeight.bold,
                                    height: 0.5),
                              ),
                              SizedBox(height: 32.0),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 32.0),
                      const Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Área do Motorista',
                                style: TextStyle(
                                    fontSize: 28.0,
                                    color: darkBlueColor,
                                    fontWeight: FontWeight.bold,
                                    height: 0.5),
                              ),
                              Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Carro atual',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: darkBlueColor,
                                          height: 0.5),
                                    ),
                                    Text(
                                      'HB20 Prata 2009',
                                      style: TextStyle(
                                          fontSize: 24.0,
                                          color: darkBlueColor,
                                          fontWeight: FontWeight.bold,
                                          height: 1.0),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      const Column( // retirar qnd for perfil de outro user
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 60.0,
                          ),
                          Text(
                            'Histórico de Caronas',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                                height: 0.5),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            'Alterar senha',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                                height: 0.5),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            'Alterar email',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                                height: 0.5),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            'Sair',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                                height: 0.5,),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            )),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 4)
    );
  }
}
