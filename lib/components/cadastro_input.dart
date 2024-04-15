import 'package:flutter/material.dart';

class CadastroInput extends StatelessWidget {
  final String labelText;
  final String placeholderText;
  final bool isObscured;
  final TextEditingController controller;

  const CadastroInput(
      {Key? key,
      required this.labelText,
      required this.placeholderText,
      required this.isObscured,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            labelText,
            style: const TextStyle(
              color: Color(0xFF0E4B7C),
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 42,
            child: TextField(
              obscureText: isObscured,
              controller: controller,
              decoration: InputDecoration(
                labelText: placeholderText,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelStyle: const TextStyle(color: Color(0xFF0E4B7C)),
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF0E4B7C)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
