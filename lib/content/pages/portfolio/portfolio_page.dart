import 'dart:io';

import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:asset_flutter/content/widgets/portfolio/investment_list.dart';
import 'package:asset_flutter/content/widgets/portfolio/portfolio.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';

class PortfolioPage extends StatelessWidget {
  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light),
      child: SafeArea(
        child: MediaQuery.of(context).orientation == Orientation.portrait || Platform.isMacOS || Platform.isWindows ? 
          NestedScrollView(
            floatHeaderSlivers: false,
            headerSliverBuilder: ((context, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.height > 600 ? 420 : 400,
                  floating: true,
                  snap: false,
                  backgroundColor: Colors.white,
                  elevation: 5,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Center(
                      child: Column(
                        children: const [
                          Portfolio(),
                          PortfolioStats(false),
                        ],
                      ),
                    ),
                  ),
                ),
              ]
            ),
            body: PortfolioInvestment()
          )
          : 
          CustomScrollView(
            physics: const ScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      children: [
                        const Portfolio(),
                        const PortfolioStats(false),
                        PortfolioInvestment()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ),
    );
  }
}


//TODO: Tests

class TestData {
  static List<TestInvestData> testInvestData = [
    const TestInvestData(300.0, 'BTC', 'USD', 'crypto', -68.28, 0.00062),
    const TestInvestData(25.0, 'MATIC', 'USD', 'crypto', 40.67, 105.2),
    const TestInvestData(167.2, 'LRC', 'USD', 'crypto', 140.67, 50.0),
    const TestInvestData(217.53, 'AAPL', 'USD', 'stock', 5.78, 35.2),
    const TestInvestData(78.4, 'INTC', 'USD', 'stock', -20.5, 3.6),
    const TestInvestData(59.21, 'OLN', 'USD', 'stock', 3.9, 10.2),
    const TestInvestData(107.32, 'AUDIO', 'USD', 'crypto', -120.5, 325.6),
    const TestInvestData(45.9, 'AVAX', 'USD', 'crypto', 34.2, 34.7),
  ];

  static List<TestSubscriptionData> testSubscriptionData = [
    TestSubscriptionData("Netflix 4K Family for Friends and Me", "Netflix Family Plan", DateTime.now(), 30, 40.5, 'TL', subscriptionImage("netflix.com"), 0xFFE53935),
    TestSubscriptionData("Spotify", null, DateTime.now().subtract(const Duration(days: 5)), 30, 27.5, 'TL', subscriptionImage("spotify.com"), 0xFF4CAF50),
    TestSubscriptionData("Playstation Plus", "Playstation Plus and this is an example of long text, lets see hot it'll behave.", DateTime.now().subtract(const Duration(days: 15)), 365, 165.2, 'TL', subscriptionImage("playstation.com"), 0xFF1976D2),
    TestSubscriptionData("Jefit", null, DateTime.now().subtract(const Duration(days: 2)), 7, 10.9, 'USD', subscriptionImage("jefit.com"), 0xFF03A9F4),
    TestSubscriptionData("WoW", null, DateTime.now().subtract(const Duration(days: 147)), 365, 60.2, 'USD', subscriptionImage("worldofwarcraft.com"), 0xFF4CAF50),
  ];

  static List<TestSubscriptionStatsData> testSubscriptionStatsData = [
    const TestSubscriptionStatsData('USD', 380.42),
    const TestSubscriptionStatsData('EUR', 85.3),
    const TestSubscriptionStatsData('TRY', 16.5),
    const TestSubscriptionStatsData('GBP', 30.1),
  ];

  static TestAssetStatsData testAssetStatsData = TestAssetStatsData(120, 536.28, 102.4, 756.46, 42202.7, -66542.5, -125324.6, -150684.46, 17.5, 67.66, 14.84);

  static List<Color> testChartStatsColor = [
    TabsPage.primaryColor,
    TabsPage.orangeColor,
    TabsPage.primaryLightColor,
    Colors.yellow
  ];

  static List<String> testChartStatsText = [
    "Stock",
    "Crypto",
    "Exchange",
    "Total"
  ];

  static List<Color> testSubscriptionStatsColor = [
    Colors.white,
    TabsPage.primaryDarkestColor,
    TabsPage.orangeColor,
    Colors.yellow
  ];

  static String stockImage(String symbol) {
    return "https://storage.googleapis.com/iex/api/logos/${symbol.toUpperCase()}.png";
  }

  static String cryptoImage(String symbol) {
    return "https://raw.githubusercontent.com/spothq/cryptocurrency-icons/master/32@2x/color/${symbol.toLowerCase()}@2x.png";
  }

  static String cryptoFailImage() {
    return "https://raw.githubusercontent.com/spothq/cryptocurrency-icons/master/32@2x/color/generic@2x.png";
  }

  static String subscriptionImage(String company) {
    return "https://logo.clearbit.com/$company";
  }

  static IconData subscriptionFailIcon(){
    return Icons.payment_rounded;
  }

  static int subscriptionStatsPercentageCalculator(List<TestSubscriptionStatsData> subsList, TestSubscriptionStatsData data) {
    double sum = subsList.fold(0, (previousValue, element) => previousValue + element.totalPayment);

    return (data.totalPayment / sum * 100).toInt();
  }
}

class TestAssetStatsData {
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

  TestAssetStatsData(
    this.stockAsset, this.cryptoAsset, this.exchangeAsset, this.totalAsset,
    this.stockPL, this.cryptoPL, this.exchangePL, this.totalPL,
    this.stockPercentage, this.cryptoPercentage, this.exchangePercentage
  );

  List<PieChartSectionData> convertDataToChart() {
    final list = List<PieChartSectionData>.empty(growable: true);
    for (var i = 0; i < 3; i++) {
      list.add(PieChartSectionData(
        color: TestData.testChartStatsColor[i],
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
            colors: [TestData.testChartStatsColor[i]],

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

class TestInvestData {
  final double value;
  final String symbol;
  final String fromAsset;
  final String type;
  final double pl;
  final double amount;

  const TestInvestData(this.value, this.symbol, this.fromAsset, this.type, this.pl, this.amount);
}

class TestSubscriptionData {
  final String name;
  final String? description;
  final DateTime billDate;
  final int billCycle;
  final double price;
  final String currency;
  final String? image;
  final int color; 

  const TestSubscriptionData(this.name, this.description, this.billDate, this.billCycle, this.price, this.currency, this.image, this.color);
}

class TestSubscriptionStatsData {
  final String currency;
  final double totalPayment;

  const TestSubscriptionStatsData(this.currency, this.totalPayment);
}