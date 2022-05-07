import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SubErrorView extends StatelessWidget {
  final String _text;
  final VoidCallback _onPressed;

  const SubErrorView(this._text, this._onPressed, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Lottie.asset(
                "assets/lottie/error.json",
                height: 50,
                width: 50,
                frameRate: FrameRate(60)
              ),
              IconButton(
                onPressed: _onPressed,
                icon: const Icon(Icons.refresh_rounded, size: 36)
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              _text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        )
      ],
    );
  }
}