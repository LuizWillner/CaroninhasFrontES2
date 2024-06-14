import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomAlertDialog extends StatefulWidget {
  final String title;
  final String content;
  final TextStyle titleStyle;
  final TextStyle contentStyle;
  final List<Widget> actions;

  const CustomAlertDialog({
    super.key,
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
  });

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title,
          style: widget.titleStyle, textAlign: TextAlign.center),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(widget.content,
                style: widget.contentStyle, textAlign: TextAlign.center),
            SizedBox(height: 20), // Espaço entre o texto e a barra de avaliação
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) =>
                  Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
          ],
        ),
      ),
      actions: widget.actions,
    );
  }
}
