import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingView extends StatelessWidget {
  final String _text;
  final Color textColor;

  const LoadingView(this._text, {this.textColor = Colors.black, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait  || Platform.isMacOS || Platform.isWindows;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: _isPortrait
        ? _body()
        : SizedBox(
          height: MediaQuery.of(context).size.height,
          child: _body()
        ),
    );
  }

  Widget _body() => Stack(
    fit: StackFit.expand,
    children: [
      Align(
        alignment: Alignment.center,
        child: Lottie.asset(
          "assets/lottie/loading.json",
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: Text(
          _text,
          style: TextStyle(
              color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      )
    ]
  );
}
