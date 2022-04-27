import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final Function onPressedHandler;
  final String text;
  final Color color;
  final double fontSize;

  const AuthButton(this.onPressedHandler, this.text, this.color,
      {this.fontSize = 18});

  @override
  Widget build(BuildContext context) {
    final bool isApple = Platform.isIOS || Platform.isMacOS;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: isApple
        ? CupertinoButton(
          color: color,
          padding: const EdgeInsets.all(12),
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize),
          ), 
          onPressed: () => onPressedHandler(context),
        )
        : ElevatedButton(
            onPressed: () => onPressedHandler(context),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                text,
                style: TextStyle(fontSize: fontSize),
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
              ),
            ),
          )
    );
  }
}
