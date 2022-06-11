import 'package:asset_flutter/content/providers/settings/theme_state.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              color: Provider.of<ThemeProvider>(context, listen: false).isDarkMode ? Colors.white54 :  Colors.black54
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
