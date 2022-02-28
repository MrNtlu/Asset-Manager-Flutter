import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AreYouSureDialog extends StatelessWidget {
  final String _content;
  final VoidCallback _onPressed;

  const AreYouSureDialog(this._content, this._onPressed, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isApple = Platform.isIOS || Platform.isMacOS;

    return isApple 
    ? CupertinoAlertDialog(
      title: const Text('Are you sure?'),
      content: Text('Do you want to $_content?'),
      actions: [
        CupertinoDialogAction(
          onPressed: (){
            Navigator.pop(context);
          },
          child: const Text('NO')
        ),
        CupertinoDialogAction(
          onPressed: _onPressed,
          child: const Text('Yes')
        )
      ],
    )
    : AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),
      title: const Text('Are you sure?'),
      content: Text('Do you want to $_content?'),
      actions: [
        TextButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: const Text('NO')
        ),
        TextButton(
          onPressed: _onPressed,
          child: const Text('Yes')
        )
      ],
    );
  }
}