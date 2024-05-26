import 'package:flutter/material.dart';

class CadastroInput extends StatelessWidget {
  final String labelText;
  final String placeholderText;
  final bool isObscured;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const CadastroInput(
      {Key? key,
      required this.labelText,
      required this.placeholderText,
      required this.isObscured,
      required this.controller,
      required this.keyboardType})
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
              keyboardType: keyboardType,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
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

class FormInput extends StatelessWidget {
  final String placeholderText;
  final bool isObscured;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final IconData fieldIcon;
  static const darkBlueColor = Color(0xFF0E4B7C);

  const FormInput(
      {Key? key,
      required this.fieldIcon,
      required this.placeholderText,
      required this.isObscured,
      required this.controller,
      required this.keyboardType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 42,
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: TextField(
                      obscureText: isObscured,
                      controller: controller,
                      keyboardType: keyboardType,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        prefixIcon: Icon(
                          fieldIcon,
                          size: 20.0,
                          color: darkBlueColor,
                        ),
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
              )
            ],
          ),
        ));
  }
}
