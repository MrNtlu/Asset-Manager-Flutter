import 'package:asset_flutter/static/chart.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AssetLog {
  final double value;
  final String toAsset;
  final String fromAsset;
  final String type;
  final double amount;
  final double? boughtPrice;
  final double? soldPrice;
  final DateTime createdAt;

  const AssetLog(
    this.value, this.toAsset, this.fromAsset, 
    this.type, this.amount, this.createdAt, 
    {this.boughtPrice, this.soldPrice}
  );
}

class AssetDetails {
  final double currentValue;
  final String name;
  final String toAsset;
  final String fromAsset;
  final String type;
  final double pl;
  final double amount;

  const AssetDetails(this.currentValue, this.name, this.toAsset, this.fromAsset, this.type, this.pl, this.amount);
}

class AssetStats {
  final String currency;
  final double totalBought;
  final double totalSold;
  final double stockAsset;
  final double cryptoAsset;
  final double exchangeAsset;
  final double totalAsset;
  final double stockPL;
  final double cryptoPL;
  final double exchangePL;
  final double totalPL;
  final double stockPercentage;
  final double cryptoPercentage;
  final double exchangePercentage;

  AssetStats(
    this.currency, this.totalBought, this.totalSold,
    this.stockAsset, this.cryptoAsset, this.exchangeAsset, this.totalAsset,
    this.stockPL, this.cryptoPL, this.exchangePL, this.totalPL,
    this.stockPercentage, this.cryptoPercentage, this.exchangePercentage
  );

  List<PieChartSectionData> convertDataToChart() {
    final list = List<PieChartSectionData>.empty(growable: true);
    for (var i = 0; i < 3; i++) {
      list.add(PieChartSectionData(
        color: ChartAttributes().chartStatsColor[i],
        value: (i == 0) ?
          stockAsset :
          (i == 1) ? 
          cryptoAsset :
          exchangeAsset
        ,
        showTitle: false,
        radius: 45,
        titleStyle: const TextStyle(
          fontWeight: FontWeight.bold, 
          color: Colors.white, 
          fontSize: 12
        ),
      ));
    }
    return list;
  }

  List<BarChartGroupData> convertDataToBarChart() {
    final list = List<BarChartGroupData>.empty(growable: true);
    for (var i = 0; i < 4; i++) {
      var value = (i == 0) ?
        stockPL :
        (i == 1) ? 
        cryptoPL :
        (i == 2) ?
        exchangePL :
        totalPL;
      value = value.revertValue();
      list.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            y: value,
            width: 25,
            borderRadius: value > 0 ?
            const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6)
            ) 
            :
            const BorderRadius.only(
              bottomLeft: Radius.circular(6),
              bottomRight: Radius.circular(6)
            ),
            colors: [ChartAttributes().chartStatsColor[i]],

          )
        ]
      ));
    }
    return list;
  }

  String convertDataToSideTitle(int index) {
    var titleValue = ((index == 0) ?
      stockPL :
      (index == 1) ? 
      cryptoPL :
      (index == 2) ?
      exchangePL :
      totalPL);
    titleValue = titleValue.revertValue();
    return titleValue.toString();
  }
}