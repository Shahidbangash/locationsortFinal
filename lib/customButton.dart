import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  VoidCallback onPressed;
  String buttonText;
  Color color;
  Color textColor;
  Color borderColor;

  CustomButton(
      {this.onPressed,
      this.buttonText,
      this.color = Colors.red,
      this.textColor = Colors.black,
      this.borderColor = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(12)),
      color: color,
      textColor: textColor,
      padding: const EdgeInsets.all(14.0),
      child: Text(buttonText),
    );
  }
}
