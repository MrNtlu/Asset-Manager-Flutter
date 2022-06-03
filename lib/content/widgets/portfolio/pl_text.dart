import 'package:asset_flutter/static/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class PortfolioPLText extends StatelessWidget {
  final double _pl;
  final double? _plPercentage;
  final double fontSize;
  final double iconSize;
  final String? _subText;
  final String? plPrefix;

  const PortfolioPLText(this._pl, this._plPercentage, this._subText, {this.fontSize = 16, this.iconSize = 18, this.plPrefix});

  @override
  Widget build(BuildContext context) {
    final isNeutral = _pl.abs() <= 0.01;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon(
        //   isNeutral
        //   ? null
        //   : (_pl < 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded),
        //   color: isNeutral
        //   ? Colors.grey
        //   : (_pl < 0 ? AppColors().greenColor : AppColors().redColor),
        //   size: iconSize,
        // ),
        if(plPrefix != null)
        Text(
          plPrefix!,
          style: TextStyle(
            fontSize: fontSize - 2,
            color: isNeutral
            ? Colors.grey
            : (_pl < 0 ? AppColors().greenColor : AppColors().redColor),
            fontWeight: FontWeight.bold
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: AutoSizeText(
            _pl.abs().toStringAsFixed(2),
            maxLines: 1,
            minFontSize: fontSize - 2,
            style: TextStyle(
              fontSize: fontSize,
              color: isNeutral
              ? Colors.grey
              : (_pl < 0 ? AppColors().greenColor : AppColors().redColor),
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        if (_plPercentage != null)
        Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Icon(
            isNeutral
            ? null
            : (_pl < 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded),
            color: isNeutral
            ? Colors.grey
            : (_pl < 0 ? AppColors().greenColor : AppColors().redColor),
            size: iconSize,
          ),
        ),
        Text(
          (_plPercentage != null 
            ? _plPercentage!.abs().toStringAsFixed(1) + '%'
            : ''
          ),
          style: TextStyle(
            fontSize: fontSize,
            color: isNeutral
            ? Colors.grey
            : (_pl < 0 ? AppColors().greenColor : AppColors().redColor),
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
              color: isNeutral
              ? Colors.grey
              : (_pl < 0 ? AppColors().greenColor : AppColors().redColor),
              fontSize: fontSize - 6,
            )
          ),
        )
      ],
    );
  }
}
