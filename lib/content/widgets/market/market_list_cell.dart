import 'package:asset_flutter/content/widgets/portfolio/il_cell_image.dart';
import 'package:asset_flutter/static/images.dart';
import 'package:asset_flutter/utils/stock_handler.dart';
import 'package:flutter/material.dart';

class MarketListCell extends StatelessWidget {
  final String _name;
  final String _symbol;
  final String _price;
  final String _type;
  final String _market;

  const MarketListCell(this._name, this._symbol, this._price, this._type, this._market, {Key? key}) : super(key: key);

  String _getImageFromType() {
    if (_type == "crypto") {
      return PlaceholderImages().cryptoImage(_symbol);
    } else if (_type == "exchange") {
      return PlaceholderImages().exchangeImage(_symbol);
    } else if (_type == "stock") {
      return 'icons/flags/png/${convertIndexNameToFlag(_market)}.png';
    } else {
      return 'assets/images/gold.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: InvestmentListCellImage(
                  _getImageFromType(), 
                  _type,
                  margin: const EdgeInsets.all(0),
                  borderRadius:  BorderRadius.circular(13),
                  size: 13,
                  boxfit: BoxFit.cover,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  _name != _symbol ? "$_name/$_symbol" : _name, 
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  _price, 
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider()
      ],
    );
  }
}