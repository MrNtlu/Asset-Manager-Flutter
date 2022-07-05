import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';

class TransactionDetailsSheetText extends StatelessWidget {
  final String _title;
  final String _value;
  final Color? textColor;
  const TransactionDetailsSheetText(this._title, this._value, {this.textColor, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            _title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.bgTransparentColor
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
              color: textColor ?? Theme.of(context).colorScheme.bgTextColor
            ),
          ),
        )
      ],
    );
  }
}
