import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:flutter/material.dart';

class CurrencyBarButton extends StatelessWidget {
  final String _text;
  final VoidCallback _onPressed;

  const CurrencyBarButton(this._text, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, right: 8, left: 8),
        child: OutlinedButton(
          onPressed: _onPressed, 
          child: Text(
            _text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: TabsPage.primaryLightishColor, width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
          ),
        ),
      ),
    );
  }
}
