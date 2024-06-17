// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  static const clearBlueColor = Color(0xFF00AFF8);
  static const darkBlueColor = Color(0xFF0E4B7C);
  final storage = const FlutterSecureStorage();
  String? isDriver;

  @override
  void initState() {
    super.initState();
    _loadIsDriver();
  }

  Future<void> _loadIsDriver() async {
    final driverStatus = await storage.read(key: "isDriver");
    setState(() {
      isDriver = driverStatus;
    });
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        if (widget.currentIndex != 0) {
          Navigator.of(context).pushNamed('/Pedir_carona');
        }
        break;
      case 1:
        if (widget.currentIndex != 1 && (isDriver == "true")) {
          Navigator.of(context).pushNamed('/Criar_carona');
        }
        break;
      case 2:
        if (widget.currentIndex != 2) {
          Navigator.of(context).pushNamed('/Historico');
        }
        break;
      case 3:
        if (widget.currentIndex != 3) {
          Navigator.of(context).pushNamed('/Perfil');
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.search, color: clearBlueColor),
          label: 'Procurar',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_circle_outline,
            color: (isDriver != "true") ? Colors.grey : clearBlueColor,            
          ),
          label: 'Oferecer',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.list, color: clearBlueColor),
          label: 'Viagens',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline, color: clearBlueColor),
          label: 'Perfil',
        ),
      ],
      currentIndex: widget.currentIndex,
      selectedItemColor: darkBlueColor,
    );
  }
}
