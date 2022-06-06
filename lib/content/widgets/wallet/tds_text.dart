import 'package:flutter/material.dart';

class TransactionDetailsSheetText extends StatelessWidget {
  final String _title;
  final String _value;
  final Color textColor;
  const TransactionDetailsSheetText(this._title, this._value, {this.textColor = Colors.black, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            _title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black54
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            _value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor
            ),
          ),
        )
      ],
    );
  }
}
