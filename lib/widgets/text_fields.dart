import 'package:flutter/material.dart';

class TextFieldCustom extends StatelessWidget {
  const TextFieldCustom({Key? key, this.obscureText = false, this.controller, this.validator, required this.labelText}) : super(key: key);


  final bool obscureText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final String labelText;


  @override
  Widget build(BuildContext context) {
    return     TextFormField(
      style: const TextStyle(fontSize: 17),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: obscureText,
      controller: controller,
      validator:validator,
      decoration:  InputDecoration(
          labelText: labelText
      ),
    );
  }
}