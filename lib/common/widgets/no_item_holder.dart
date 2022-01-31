import 'package:asset_flutter/common/widgets/add_elevated_button.dart';
import 'package:flutter/material.dart';

class NoItemHolder extends StatelessWidget {
  final String _text;
  final String _buttonText;
  final double height;

  const NoItemHolder(this._text, this._buttonText,{Key? key, this.height = 250}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 12),
          AddElevatedButton(_buttonText, (){

          })
        ],
      ),
    );
  }
}
