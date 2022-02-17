import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoItemHolder extends StatelessWidget {
  final String _text;
  final double height;

  const NoItemHolder(this._text, {Key? key, this.height = 250}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait 
      ? Expanded(child: _body())
      : SizedBox(
          height: 250,
          child: _body(),
        );
  }

  Widget _body() => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Lottie.asset(
        "assets/lottie/no_item.json",
        height: 200,
        width: 200
      ),
      Text(
        _text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
      )
    ],
  );
}
