import 'package:asset_flutter/static/chart.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AssetLog {
  final String id;
  num value;
  final String toAsset;
  final String fromAsset;
  final String type;
  final num amount;
  final num? boughtPrice;
  final num? soldPrice;
  final DateTime createdAt;

  AssetLog(
    this.id, this.value, this.toAsset, this.fromAsset, 
    this.type, this.amount, this.createdAt, 
    {this.boughtPrice, this.soldPrice}
  );
}

class AssetStats {
  final String currency;
  final num totalBought;
  final num totalSold;
  final num stockAsset;
  final num cryptoAsset;
  final num exchangeAsset;
  final num totalAsset;
  final num stockPL;
  final num cryptoPL;
  final num exchangePL;
  final num totalPL;
  final num stockPercentage;
  final num cryptoPercentage;
  final num exchangePercentage;

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
        value: ((i == 0) ?
          stockAsset :
          (i == 1) ? 
          cryptoAsset :
          exchangeAsset).toDouble()
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
      value = double.parse((value.toDouble()).revertValue().toStringAsFixed(2));
      list.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            y: value.toDouble(),
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
    titleValue = (titleValue.toDouble()).revertValue();
    return titleValue.toString();
  }
}