import 'package:asset_flutter/content/models/responses/subscription.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';

class StatsBar {
  List<Color> statsColor = [
    Colors.white,
    AppColors().primaryDarkestColor,
    AppColors().orangeColor,
    Colors.yellow
  ];

  StatsBar._privateConstructor();

  static final StatsBar _instance = StatsBar._privateConstructor();

  factory StatsBar() {
    return _instance;
  }

  int subscriptionStatsPercentageCalculator(List<SubscriptionStats> subsList, double data) {
    double sum = subsList.fold(0, (previousValue, element) => previousValue + element.totalPayment);

    return (data / sum * 100).toInt();
  }
}