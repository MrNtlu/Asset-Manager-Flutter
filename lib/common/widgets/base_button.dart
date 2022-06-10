import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  final String _text;
  final VoidCallback _onPressed;
  final Icon? icon;
  final Alignment alignment;
  final EdgeInsets containerMargin;

  const BaseButton(
    this._text,
    this._onPressed,
    {
      this.icon,
      required this.containerMargin,
      this.alignment = Alignment.centerRight,
      Key? key
    }
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: containerMargin,
      width: double.infinity,
      child: Platform.isIOS || Platform.isMacOS
      ? CupertinoButton.filled(
        onPressed: _onPressed,
        padding: const EdgeInsets.all(12),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              _text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
            Align(
              alignment: alignment,
              child: icon
            ),
          ],
        ), 
      )
      : ElevatedButton(
        onPressed: _onPressed,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              _text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold
              )
            ),
            Align(
              alignment: alignment,
              child: icon
            ),
          ],
        ),
      ),
    );
  }
}