import 'dart:io';

import 'package:asset_flutter/static/colors.dart';
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
        ? _body(context)
        : SizedBox(
          height: MediaQuery.of(context).size.height,
          child: _body(context)
        ),
    );
  }

  Widget _body(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      Align(
        alignment: Alignment.center,
        child: Lottie.asset(
          "assets/lottie/loading.json",
          frameRate: FrameRate(60)
        ),
      ),
      Align(
        alignment: Alignment.center,
        child: Text(
          _text,
          style: TextStyle(color: textColor == Colors.black ? Theme.of(context).colorScheme.bgTextColor : textColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      )
    ]
  );
}
