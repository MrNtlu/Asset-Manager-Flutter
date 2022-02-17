import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingView extends StatelessWidget {
  final String _text;

  const LoadingView(this._text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Stack(
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
              style: const TextStyle(
                  color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          )
        ]
      ),
    );
  }
}
