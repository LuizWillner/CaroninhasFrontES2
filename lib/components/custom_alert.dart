import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final TextStyle titleStyle;
  final TextStyle contentStyle;
  final List<Widget> actions;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.actions,
    this.titleStyle = const TextStyle(
      color: Color(0xFF0E4B7C),
      fontWeight: FontWeight.w900,
      fontSize: 30,
    ),
    this.contentStyle = const TextStyle(
      color: Color(0xFF0E4B7C),
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: titleStyle, textAlign: TextAlign.center),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(content, style: contentStyle, textAlign: TextAlign.center),
          ],
        ),
      ),
      actions: actions,
    );
  }
}
