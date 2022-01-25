import 'package:flutter/material.dart';

class SubscriptionCurrencyBarInfoText extends StatelessWidget {
  final Color _color;
  final String _currencyText;

  const SubscriptionCurrencyBarInfoText(this._color, this._currencyText);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              height: 14,
              width: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _color,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              _currencyText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _color,
              ),
            )
          ],
        ),
      ),
    );
  }
}
