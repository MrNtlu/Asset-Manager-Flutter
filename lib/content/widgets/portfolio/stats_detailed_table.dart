import 'package:asset_flutter/content/pages/portfolio/portfolio_page.dart';
import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';

class PortfolioStatsDetailedTable extends StatelessWidget {
  const PortfolioStatsDetailedTable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _textSize = MediaQuery.of(context).size.width > 370 ? 16 : 14;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(3),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        child: DataTable(
          border: TableBorder.all(
            borderRadius: BorderRadius.circular(9),
            width: 1,
            color: TabsPage.primaryLightishColor,
          ),
          dividerThickness: 1,
          headingRowColor: MaterialStateColor.resolveWith((states) => TabsPage.primaryLightishColor),
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
                  'Value ('+TestData.testAssetStatsData.currency+')',
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
            _statsDataRow('Total Wealth', TestData.testAssetStatsData.totalAsset, _textSize),
            _statsDataRow('Stock', TestData.testAssetStatsData.stockAsset, _textSize),
            _statsDataRow('Crypto', TestData.testAssetStatsData.cryptoAsset, _textSize),
            _statsDataRow('Exchange', TestData.testAssetStatsData.exchangeAsset, _textSize),
            _statsDataRow('Total Profit/Loss', TestData.testAssetStatsData.totalPL.revertValue(), _textSize),
            _statsDataRow('Stock Profit/Loss', TestData.testAssetStatsData.stockPL.revertValue(), _textSize),
            _statsDataRow('Crypto Profit/Loss', TestData.testAssetStatsData.cryptoPL.revertValue(), _textSize),
            _statsDataRow('Exchange Profit/Loss', TestData.testAssetStatsData.exchangePL.revertValue(), _textSize),
            _statsDataRow('Total Bought', TestData.testAssetStatsData.totalBought, _textSize),
            _statsDataRow('Total Sold', TestData.testAssetStatsData.totalSold, _textSize),
          ],
        ),
      ),
    );
  }

  DataRow _statsDataRow(String type, double value, textSize) {
    
    return DataRow(
      cells: [
        DataCell(Text(type, style: TextStyle(fontSize: textSize))),
        DataCell(Text(value.toString(), style: TextStyle(fontSize: textSize, fontWeight: FontWeight.bold))),
      ],
    );
  }
}