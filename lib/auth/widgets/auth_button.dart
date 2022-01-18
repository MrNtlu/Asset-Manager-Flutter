import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final VoidCallback onPressedHandler;
  final String text;
  final Color color;
  final double fontSize;

  const AuthButton(this.onPressedHandler, this.text, this.color,{this.fontSize = 18});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: ElevatedButton(
        onPressed: onPressedHandler,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize),
          ),
        ),
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(color)),
      ),
    );
  }
}
