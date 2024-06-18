import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Color clearBlueColor = Color(0xFF00AFF8);
const Color darkBlueColor = Color(0xFF0E4B7C);

class AddressesPainter extends CustomPainter {
  final List<String> addresses;
  final double circleRadius = 8.0;
  final double circleSpacing = 40.0;
  int drawCircleCount = 0;

  AddressesPainter(this.addresses);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint circlePaint = Paint()
      ..color = darkBlueColor
      ..style = PaintingStyle.fill;

    final Paint linePaint = Paint()
      ..color = darkBlueColor
      ..strokeWidth = 1.0;

    for (int i = 0; i < addresses.length; i++) {
      double dy = circleSpacing * i * 1.2;
      double textSpacing = 25;
      Offset circleOffset = Offset(circleRadius - textSpacing, dy);

      canvas.drawCircle(circleOffset, circleRadius, circlePaint);
      drawCircleCount++; // Incrementa o contador de chamadas drawCircle

      if (i < addresses.length - 1) {
        double nextDy = circleSpacing * (i + 1) * 1.2;
        Offset nextCircleOffset = Offset(circleRadius - textSpacing, nextDy);
        canvas.drawLine(circleOffset, nextCircleOffset, linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

void main() {
  testWidgets('Counts drawCircle calls', (WidgetTester tester) async {
    List<String> addresses = ["Address 1", "Address 2", "Address 3"];
    AddressesPainter painter = AddressesPainter(addresses);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 200,
              height: addresses.length * 50.0,
              child: CustomPaint(
                painter: painter,
                size: Size(200, addresses.length * 50.0),
              ),
            ),
          ),
        ),
      ),
    );

    // Verifica se o método drawCircle foi chamado o número correto de vezes
    expect(painter.drawCircleCount, addresses.length);
  });
}
