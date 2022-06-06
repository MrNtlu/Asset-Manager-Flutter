import 'package:asset_flutter/content/providers/wallet/transaction.dart';
import 'package:asset_flutter/content/providers/wallet/transaction_stats.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TransactionStatsCategoryDistribution extends StatelessWidget {
  const TransactionStatsCategoryDistribution({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionStatsProvider>(builder: (context, value, _) {
      final data = value.item!.categoryStats;
      final _categoryList = data.categoryList;
      
      return SfCircularChart(
        legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap, position: LegendPosition.auto), 
        series: <CircularSeries>[
          PieSeries<PieChartData, String>(
            dataSource: _categoryList.isNotEmpty
            ? _categoryList.map((e) {
              final category = Category.valueToCategory(e.categoryID);
              return PieChartData(
                "${category.name[0].toUpperCase()}${category.name.substring(1, category.name.length)}", 
                e.totalCategoryTransaction.toDouble().abs(), 
                category.iconColor
              );
            }).toList()
            : Category.values.map((e) => PieChartData(
              "${e.name[0].toUpperCase()}${e.name.substring(1, e.name.length)}", 
              1, e.iconColor)
            ).toList(),
            pointColorMapper:(PieChartData data, _) => data.color,
            xValueMapper: (PieChartData data, _) => data.x,
            yValueMapper: (PieChartData data, _) => data.y,
            dataLabelMapper: (pieChartData, _) => data.currency.getCurrencyFromString() + pieChartData.y.numToString(),
            dataLabelSettings: DataLabelSettings(
              isVisible: _categoryList.isNotEmpty, 
              useSeriesColor: true,
            ),
            radius: '75%'
          )
        ]
      ); 
    });
  }
}

class PieChartData {
  PieChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}