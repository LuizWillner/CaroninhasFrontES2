import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:app_uff_caronas/components/viagem.dart';

void main() {
  testWidgets('Viagem widget test', (WidgetTester tester) async {
    const String image = "assets/login_background.png";
    const String partida = 'Partida A';
    const String chegada = 'Chegada B';
    const String nome = 'Motorista X';
    final DateTime data = DateTime(2024, 6, 17, 10, 0);
    const double price = 50.0;
    const int vagasRestantes = 3;
    const String buttonInnerText = 'Reservar';

    void onPressed() {
      print('Button pressed');
    }

    await tester.pumpWidget(MaterialApp(
      home: Viagem(
        image: image,
        partida: partida,
        chegada: chegada,
        nome: nome,
        data: data,
        onPressed: onPressed,
        price: price,
        vagasRestantes: vagasRestantes,
        buttonInnerText: buttonInnerText,
      ),
    ));

    // Verificações dos componentes do widget
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('De: $partida\nPara: $chegada'), findsOneWidget);
    expect(find.text(DateFormat('dd/MM/yyyy').format(data)), findsOneWidget);
    expect(find.text(DateFormat('HH:mm').format(data)), findsOneWidget);
    expect(find.text('Motorista: $nome'), findsOneWidget);
    expect(find.text('R\$ ${price.toStringAsFixed(2).replaceAll(".", ",")}'), findsOneWidget);
    expect(find.text(buttonInnerText), findsOneWidget);

    // Simula um toque no botão e verifica se o callback é chamado
    await tester.tap(find.byType(OutlinedButton));
    await tester.pump();
  });
}
