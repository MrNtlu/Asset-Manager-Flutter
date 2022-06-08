import 'dart:io';

import 'package:asset_flutter/content/providers/asset.dart';
import 'package:asset_flutter/content/widgets/portfolio/il_cell_image.dart';
import 'package:asset_flutter/content/widgets/portfolio/pl_text.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class InvestmentDetailsTopBar extends StatelessWidget {
  final Asset _data;
  final String image;

  const InvestmentDetailsTopBar(this._data, this.image, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (Platform.isIOS || Platform.isMacOS) ? 123 : 105,
      padding: EdgeInsets.fromLTRB(4, 4, 4, ((Platform.isIOS || Platform.isMacOS) ? 24 : 6)),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        color: AppColors().primaryLightishColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0.0, 1.0),
            blurRadius: 3.0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              InvestmentListCellImage(image, _data.type),
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: AutoSizeText(
                    _data.type != "stock"
                    ? _data.toAsset + '/' + _data.fromAsset
                    : _data.toAsset,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    maxFontSize: 20,
                    minFontSize: 16,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(right: 12),
                      child: AutoSizeText(
                        _data.currentValue.numToString() + ' ' + _data.fromAsset,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        maxFontSize: 18,
                        minFontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 12, top: 4),
                      child: PortfolioPLText(
                        _data.pl.toDouble(), 
                        _data.plPercentage.toDouble(),
                        null,
                        fontSize: 15,
                        iconSize: 17,
                        plPrefix: _data.fromAsset.getCurrencyFromString()
                      )
                    )
                  ],
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            child: Text(
              _data.type != "stock"
              ? _data.amount.numToString() + ' ' + _data.toAsset
              : "${_data.amount.numToString()} shares",
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      ),
    );
  }
}