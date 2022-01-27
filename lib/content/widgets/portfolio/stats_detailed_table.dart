import 'package:asset_flutter/content/pages/portfolio/portfolio_page.dart';
import 'package:flutter/material.dart';
import 'package:asset_flutter/utils/extensions.dart';

class PortfolioStatsDetailedTable extends StatelessWidget {
  const PortfolioStatsDetailedTable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DataTable(
        columns: const[
          DataColumn(
            label: Text(
              '',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          DataColumn(
            numeric: true,
            label: Text(
              'Value (USD)',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ],
        rows: [
          DataRow(
            cells: [
              const DataCell(Text('Stock')),
              DataCell(Text(TestData.testAssetStatsData.stockAsset.toString())),
            ],
          ),
          DataRow(
            cells: [
              const DataCell(Text('Crypto')),
              DataCell(Text(TestData.testAssetStatsData.cryptoAsset.toString())),
            ],
          ),
          DataRow(
            cells: [
              const DataCell(Text('Exchange')),
              DataCell(Text(TestData.testAssetStatsData.exchangeAsset.toString())),
            ],
          ),
          DataRow(
            cells: [
              const DataCell(Text('Total')),
              DataCell(Text(TestData.testAssetStatsData.totalAsset.toString())),
            ],
          ),
          DataRow(
            cells: [
              const DataCell(Text('Stock Profit/Loss')),
              DataCell(Text(TestData.testAssetStatsData.stockPL.revertValue().toString())),
            ],
          ),
          DataRow(
            cells: [
              const DataCell(Text('Crypto Profit/Loss')),
              DataCell(Text(TestData.testAssetStatsData.cryptoPL.revertValue().toString())),
            ],
          ),
          DataRow(
            cells: [
              const DataCell(Text('Exchange Profit/Loss')),
              DataCell(Text(TestData.testAssetStatsData.exchangePL.revertValue().toString())),
            ],
          ),
          DataRow(
            cells: [
              const DataCell(Text('Total Profit/Loss')),
              DataCell(Text(TestData.testAssetStatsData.totalPL.revertValue().toString())),
            ],
          ),
        ],
      ),
    );
  }
}