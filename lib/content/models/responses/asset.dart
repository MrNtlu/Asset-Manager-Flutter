import 'package:asset_flutter/static/chart.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AssetLog {
  final String id;
  num value;
  final String toAsset;
  final String fromAsset;
  String type;
  num amount;
  final DateTime createdAt;
  num price;
  final String market;

  AssetLog(this.id, this.value, this.toAsset, this.fromAsset, this.type,
      this.amount, this.createdAt, this.price, this.market);
}

class AssetStats {
  final String currency;
  final num totalBought;
  final num totalSold;
  final num stockAsset;
  final num cryptoAsset;
  final num exchangeAsset;
  final num commodityAsset;
  final num totalAsset;
  final num stockPL;
  final num cryptoPL;
  final num exchangePL;
  final num commodityPL;
  final num totalPL;
  final num totalPLPercentage;
  final num stockPercentage;
  final num cryptoPercentage;
  final num exchangePercentage;
  final num commodityPercentage;

  AssetStats(
    this.currency,
    this.totalBought,
    this.totalSold,
    this.stockAsset,
    this.cryptoAsset,
    this.exchangeAsset,
    this.commodityAsset,
    this.totalAsset,
    this.stockPL,
    this.cryptoPL,
    this.exchangePL,
    this.commodityPL,
    this.totalPL,
    this.totalPLPercentage,
    this.stockPercentage,
    this.cryptoPercentage,
    this.exchangePercentage,
    this.commodityPercentage
  );

  List<PieChartSectionData> convertDataToChart({isDetails = false}) {
    final list = List<PieChartSectionData>.empty(growable: true);
    for (var i = 0; i < 4; i++) {
      var percentageData = ((i == 0)
        ? commodityPercentage
        : (i == 1)
            ? cryptoPercentage
            : (i == 2)
              ? exchangePercentage
              : stockPercentage).toDouble();
      list.add(PieChartSectionData(
        color: ChartAttributes().chartStatsColor[i],
        value: percentageData,
        title: percentageData.toStringAsFixed(1),
        showTitle: isDetails,
        radius: 47,
        titleStyle: const TextStyle(
          fontWeight: FontWeight.bold, 
          color: Colors.white,
          fontSize: 10
        ),
      ));
    }
    return list;
  }

  List<double> convertDataToDouble() {
    final list = List<double>.empty(growable: true);
    for (var i = 0; i < 5; i++) {
      var value = (i == 0)
          ? commodityPL
          : (i == 1)
              ? cryptoPL
              : (i == 2)
                  ? exchangePL
                  : (i == 3)
                    ? stockPL
                    : totalPL;
      var absValue = double.parse((value.toDouble()).abs().toStringAsFixed(2));
      list.add(absValue);
    }
    return list;
  }

  List<Color> convertDataToTitle() {
    final list = List<Color>.empty(growable: true);
    for (var i = 0; i < 5; i++) {
      var value = (i == 0)
          ? commodityPL
          : (i == 1)
              ? cryptoPL
              : (i == 2)
                  ? exchangePL
                  : (i == 3)
                    ? stockPL
                    : totalPL;
      list.add(value.toDouble() > 0 ? const Color(0xffff5182) : const Color(0xff53fdd7));
    }
    return list;
  }

  List<BarChartGroupData> convertDataToBarChart() {
    final list = List<BarChartGroupData>.empty(growable: true);
    for (var i = 0; i < 5; i++) {
      var value = (i == 0)
          ? commodityPL
          : (i == 1)
              ? cryptoPL
              : (i == 2)
                  ? exchangePL
                  : (i == 3)
                    ? stockPL
                    : totalPL;
      var absValue = double.parse((value.toDouble()).abs().toStringAsFixed(2));
      list.add(BarChartGroupData(x: i, barRods: [
        BarChartRodData(
          toY: absValue.toDouble(),
          width: 25,
          borderRadius: absValue > 0
              ? const BorderRadius.only(
                  topLeft: Radius.circular(6), topRight: Radius.circular(6))
              : const BorderRadius.only(
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6)),
          colors: [value.toDouble() > 0 ? const Color(0xffff5182) : const Color(0xff53fdd7)],
        )
      ]));
    }
    return list;
  }

  String convertDataToSideTitle(int index) {
    var titleValue = ((index == 0)
        ? stockPL
        : (index == 1)
            ? cryptoPL
            : (index == 2)
                ? exchangePL
                : (index == 3)
                  ? commodityPL
                  : totalPL);
    titleValue = (titleValue.toDouble()).revertValue();
    return titleValue.toString();
  }
}
