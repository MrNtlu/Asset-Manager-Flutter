import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddElevatedButton extends StatelessWidget {
  final String _label;
  final VoidCallback _onPressed;
  final EdgeInsets edgeInsets;

  const AddElevatedButton(this._label, this._onPressed,{Key? key, this.edgeInsets = const EdgeInsets.all(8)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isApple = Platform.isIOS || Platform.isMacOS;

    return Container(
      margin: edgeInsets,
      width: double.infinity,
      child: isApple 
      ? CupertinoButton.filled(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.add_circle, size: 22, color: Colors.white),
            ),
            Text(_label, style: const TextStyle(fontSize: 18, color: Colors.white)),
          ],
        ), 
        onPressed: _onPressed,
      )
      : ElevatedButton.icon(
        onPressed: _onPressed,
        label: Text(_label, style: const TextStyle(fontSize: 18, color: Colors.white)),
        icon: const Icon(Icons.add_circle, size: 22, color: Colors.white),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          ),
        ),
      )
    );
  }
}
