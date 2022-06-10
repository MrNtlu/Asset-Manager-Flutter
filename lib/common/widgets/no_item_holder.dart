import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoItemView extends StatelessWidget {
  final String _text;
  final double height;
  final Color? textColor;

  const NoItemView(this._text, {Key? key, this.height = 250, this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait 
      ? _body(context)
      : SizedBox(
          height: 250,
          child: _body(context),
        );
  }

  Widget _body(BuildContext context) => Column(
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
          color: textColor ?? Theme.of(context).colorScheme.bgTextColor,
          fontSize: 18,
        ),
      )
    ],
  );
}
