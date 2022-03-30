import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';

class ChartAttributes {
  final List<String> chartStatsText = [
    "Stock",
    "Crypto",
    "Exchange",
    "Commodity",
    "Total"
  ];

  List<Color> chartStatsColor = [
    AppColors().primaryColor,
    AppColors().orangeColor,
    Colors.red,
    AppColors().primaryLightColor,
    Colors.yellow
  ];

  ChartAttributes._privateConstructor();

  static final ChartAttributes _instance = ChartAttributes._privateConstructor();

  factory ChartAttributes() {
    return _instance;
  }
}