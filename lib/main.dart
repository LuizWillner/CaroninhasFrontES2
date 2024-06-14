import 'package:flutter/material.dart';
import 'package:app_uff_caronas/route_generator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Navegação",
      initialRoute: '/Perfil',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
