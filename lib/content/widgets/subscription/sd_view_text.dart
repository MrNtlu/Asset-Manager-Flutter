import 'package:flutter/material.dart';

class SDViewText extends StatelessWidget {
  final String _headerText;
  final String _subText;

  const SDViewText(this._headerText, this._subText, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.all(6),
            child: Text(
             _headerText,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.all(6),
            child: Text(
              _subText,
              style: const TextStyle(fontSize: 17),
            ),
          ),
          const Divider()
        ],
      ),
    );
  }
}
