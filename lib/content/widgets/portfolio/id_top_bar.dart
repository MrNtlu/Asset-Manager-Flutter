import 'package:asset_flutter/content/providers/asset.dart';
import 'package:asset_flutter/content/widgets/portfolio/il_cell_image.dart';
import 'package:asset_flutter/content/widgets/portfolio/pl_text.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/utils/currency_handler.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';

class InvestmentDetailsTopBar extends StatelessWidget {
  final Asset _data;
  final String image;

  const InvestmentDetailsTopBar(this._data, this.image, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors().primaryLightishColor,
        borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(36),
            bottomLeft: Radius.circular(36)),
      ),
      height: 105,
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 6),
      child: Column(
        children: [
          Row(
            children: [
              InvestmentListCellImage(image, _data.type),
              Container(
                margin: const EdgeInsets.only(left: 8),
                child: Text(
                  _data.toAsset + '/' + _data.fromAsset,
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 12),
                      child: Text(
                        _data.currentValue.numToString() + ' ' + _data.fromAsset,
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        padding:
                            const EdgeInsets.only(right: 12, top: 4),
                        child: PortfolioPLText(_data.pl.toDouble(), null,
                            fontSize: 15,
                            iconSize: 17,
                            plPrefix: convertCurrencyToSymbol(_data.fromAsset)))
                  ],
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            child: Text(
              _data.amount.numToString() + ' ' + _data.toAsset,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}