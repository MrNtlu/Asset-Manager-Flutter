import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:flutter/material.dart';

class PortfolioPLText extends StatelessWidget {
  final double _pl;
  final double fontSize;
  final double iconSize;
  final String? _subText;
  final String? plPrefix;

  const PortfolioPLText(this._pl, this._subText, {this.fontSize = 16, this.iconSize = 18, this.plPrefix});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          _pl < 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
          color: _pl < 0 ? TabsPage.greenColor : TabsPage.redColor,
          size: iconSize,
        ),
        Text(
          plPrefix != null ? plPrefix! + _pl.abs().toString() : _pl.abs().toString(),
          style: TextStyle(
            fontSize: fontSize,
            color: _pl < 0 ? TabsPage.greenColor : TabsPage.redColor,
            fontWeight: FontWeight.bold

          ),
        ),
        if (_subText != null)
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 4),
            child: Text(
              _subText!, 
              style: TextStyle(
                color: _pl < 0 ? TabsPage.greenColor : TabsPage.redColor,
                fontSize: fontSize - 6,
              )
            ),
          )
      ],
    );
  }
}
