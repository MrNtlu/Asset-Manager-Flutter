import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String _mainTitle;
  final String _subTitle;
  final double mainFontSize;
  final Color textColor;

  const SectionTitle(this._mainTitle, this._subTitle, {this.mainFontSize = 20, this.textColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                _mainTitle,
                style: TextStyle(
                  color: textColor,
                  fontSize: mainFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                _subTitle,
                style: TextStyle(color: textColor, fontSize: 14,fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )
      ],
    );
  }
}
