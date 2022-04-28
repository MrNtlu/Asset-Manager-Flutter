import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';

class PortfolioPLText extends StatelessWidget {
  final double _pl;
  final double _plPercentage;
  final double fontSize;
  final double iconSize;
  final String? _subText;
  final String? plPrefix;

  const PortfolioPLText(this._pl, this._plPercentage, this._subText, {this.fontSize = 16, this.iconSize = 18, this.plPrefix});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          _pl == 0 
          ? Icons.remove_rounded
          : (_pl < 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded),
          color: _pl == 0 
          ? Colors.grey
          : (_pl < 0 ? AppColors().greenColor : AppColors().redColor),
          size: iconSize,
        ),
        if(plPrefix != null)
          Text(
            plPrefix!,
            style: TextStyle(
              fontSize: fontSize - 2,
              color:_pl == 0 
              ? Colors.grey
              : (_pl < 0 ? AppColors().greenColor : AppColors().redColor),
              fontWeight: FontWeight.bold

            ),
          ),
        Text(
          _pl.abs().toStringAsFixed(2) 
          + (_pl == 0 ? ' ': (_pl < 0 ? ' +' : ' -')) 
          + _plPercentage.abs().toStringAsFixed(1) + '%',
          style: TextStyle(
            fontSize: fontSize,
            color:_pl == 0 
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
                color: _pl == 0 
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
