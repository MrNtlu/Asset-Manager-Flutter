import 'package:asset_flutter/content/providers/assets.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PortfolioStatsDetailedTable extends StatelessWidget {
  const PortfolioStatsDetailedTable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _textSize = MediaQuery.of(context).size.width > 370 ? 16 : 14;
    final assetStatsProvider = Provider.of<AssetsProvider>(context, listen: false);
    final assetStats = assetStatsProvider.assetStats;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
            child: Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              child: DataTable(
                border: TableBorder.all(
                  borderRadius: BorderRadius.circular(9),
                  width: 1,
                  color: AppColors().barCardColor,
                ),
                dividerThickness: 1,
                headingRowColor: MaterialStateColor.resolveWith((states) => Colors.black),
                columns: [
                  DataColumn(
                    label: Text(
                      'Detailed Stats',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: _textSize
                      ),
                    ),
                  ),
                  DataColumn(
                    numeric: true,
                    label: FittedBox(
                      child: Text(
                        'Value ('+assetStats!.currency+')',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: _textSize
                        ),
                      ),
                    ),
                  ),
                ],
                rows: [
                  _statsDataRow('Total Wealth', assetStats.totalAsset, _textSize),
                  _statsDataRow('Stock', assetStats.stockAsset, _textSize),
                  _statsDataRow('Crypto', assetStats.cryptoAsset, _textSize),
                  _statsDataRow('Exchange', assetStats.exchangeAsset, _textSize),
                  _statsDataRow('Commodity', assetStats.commodityAsset, _textSize),
                  _statsDataRow('Total Profit/Loss', assetStats.totalPL.toDouble().revertValue(), _textSize),
                  _statsDataRow('Stock Profit/Loss', assetStats.stockPL.toDouble().revertValue(), _textSize),
                  _statsDataRow('Crypto Profit/Loss', assetStats.cryptoPL.toDouble().revertValue(), _textSize),
                  _statsDataRow('Exchange Profit/Loss', assetStats.exchangePL.toDouble().revertValue(), _textSize),
                  _statsDataRow('Commodity Profit/Loss', assetStats.commodityPL.toDouble().revertValue(), _textSize),
                  _statsDataRow('Total Bought', assetStats.totalBought, _textSize),
                  _statsDataRow('Total Sold', assetStats.totalSold, _textSize),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _statsDataRow(String type, num value, textSize) {
    
    return DataRow(
      cells: [
        DataCell(Text(type, style: TextStyle(fontSize: textSize))),
        DataCell(Text(value.numToString(), style: TextStyle(fontSize: textSize, fontWeight: FontWeight.bold))),
      ],
    );
  }
}