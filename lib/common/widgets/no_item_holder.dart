import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoItemView extends StatelessWidget {
  final String _text;
  final double height;
  final Color textColor;

  const NoItemView(this._text, {Key? key, this.height = 250, this.textColor = Colors.black,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait 
      ? _body()
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
        width: 200,
        frameRate: FrameRate(60)
      ),
      Text(
        _text,
        style: TextStyle(
          color: textColor,
          fontSize: 18,
        ),
      )
    ],
  );
}
