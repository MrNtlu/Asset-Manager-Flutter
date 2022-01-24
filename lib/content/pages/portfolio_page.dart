import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:asset_flutter/content/widgets/portfolio/investment_list.dart';
import 'package:asset_flutter/content/widgets/portfolio/portfolio.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats.dart';
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
        child: MediaQuery.of(context).orientation == Orientation.portrait ? 
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
                        children: [
                          Portfolio(),
                          const PortfolioStats(),
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
                        Portfolio(),
                        const PortfolioStats(),
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

List<PieChartSectionData> getSections() => PieData.data
    .asMap()
    .map<int, PieChartSectionData>((index, data) {
      final value = PieChartSectionData(
        color: data.color,
        value: data.percent,
        showTitle: false,
        radius: 45,
        titleStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
      );
      return MapEntry(index, value);
    })
    .values
    .toList();

class PieData {
  static List<Data> data = [
    Data(name: 'Crypto', percent: 40, color: TabsPage.primaryColor),
    Data(name: 'Exchange', percent: 10, color: TabsPage.orangeColor),
    Data(name: 'Stock', percent: 50, color: TabsPage.primaryLightColor),
  ];
}

class Data {
  final String name;
  final double percent;
  final Color color;

  Data({required this.name, required this.percent, required this.color});
}

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

  static String stockImage(String symbol) {
    return "https://storage.googleapis.com/iex/api/logos/${symbol.toUpperCase()}.png";
  }

  static String cryptoImage(String symbol) {
    return "https://raw.githubusercontent.com/spothq/cryptocurrency-icons/master/32@2x/color/${symbol.toLowerCase()}@2x.png";
  }

  static String cryptoFailImage() {
    return "https://raw.githubusercontent.com/spothq/cryptocurrency-icons/master/32@2x/color/generic@2x.png";
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