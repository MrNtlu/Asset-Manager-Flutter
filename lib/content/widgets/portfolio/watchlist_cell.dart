import 'package:asset_flutter/content/models/responses/favourite_investment.dart';
import 'package:asset_flutter/content/widgets/portfolio/il_cell_image.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/images.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:asset_flutter/utils/stock_handler.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class WatchlistCell extends StatelessWidget {
  final FavouriteInvesting _data;

  const WatchlistCell(this._data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      width: 150,
      child: Card(
        color: AppColors().primaryLightishColor,
        elevation: 4,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(
                  _data.investingID.symbol,
                  textAlign: TextAlign.start,
                  maxFontSize: 16,
                  minFontSize: 14,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    _data.currency.getCurrencyFromString() + ' ' + _data.price.numToString(),
                    textAlign: TextAlign.center,
                    maxFontSize: 18,
                    minFontSize: 12,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                  ),
                ),
              ),
              InvestmentListCellImage(
                _getImageFromType(
                  _data.investingID.type, 
                  _data.investingID.symbol, 
                  _data.investingID.market
                ), 
                _data.investingID.type, 
                size: 18,
                margin: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getImageFromType(String _type, String _symbol, String _market) {
    if (_type == "crypto") {
      return PlaceholderImages().cryptoImage(_symbol);
    } else if (_type == "stock") {
      return 'icons/flags/png/${convertIndexNameToFlag(_market)}.png';
    } else {
      return 'assets/images/gold.png';
    }
  }
}