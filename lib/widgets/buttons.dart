import 'package:flutter/material.dart';

class ButtonCustom extends StatelessWidget {
  const ButtonCustom({
    Key? key, required this.onPressed, required this.buttonName,
  }) : super(key: key);
  final VoidCallback onPressed;

  final Widget buttonName;


  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.blue,
      elevation: 0,
      height: 50,
      minWidth: double.maxFinite,
      onPressed: onPressed,
      child: buttonName,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)),
    );
  }
}