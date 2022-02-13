import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  final String _text;

  const LoadingView(this._text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      height: 75,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CircularProgressIndicator(),
            Text(
              _text,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            )
          ]),
    ));
  }
}
