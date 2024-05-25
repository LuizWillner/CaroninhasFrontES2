import 'package:flutter/material.dart';

const Color clearBlueColor = Color(0xFF00AFF8);
const Color darkBlueColor = Color(0xFF0E4B7C);

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (int index) {
        switch (index) {
          case 0:
            if (currentIndex != 0) {
              Navigator.of(context).pushNamed('/Pedir_carona');
            }            
            break;
          case 1:
            if (currentIndex != 1) {
              Navigator.of(context).pushNamed('/Criar_carona');
            } 
            break;
          case 2:
            if (currentIndex != 2) {
              Navigator.of(context).pushNamed('/Detalhes_carona');
            }
            break;
          case 3:
            if (currentIndex != 3) {
              Navigator.of(context).pushNamed('/Home');
            } 
            break;
          case 4:
            if (currentIndex != 4) {
              Navigator.of(context).pushNamed('/Perfil');
            } 
            break;
          default:
            break;
        }
      },
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.search, color: clearBlueColor),
          label: 'Procurar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline, color: clearBlueColor),
          label: 'Oferecer',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list, color: clearBlueColor),
          label: 'Viagens',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message_outlined, color: clearBlueColor),
          label: 'Mensagens',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline, color: clearBlueColor),
          label: 'Perfil',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: darkBlueColor,
    );
  }
}
