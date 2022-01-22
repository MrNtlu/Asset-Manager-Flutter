import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:asset_flutter/content/widgets/portfolio_investment.dart';
import 'package:asset_flutter/content/widgets/portfolio_main_section.dart';
import 'package:asset_flutter/content/widgets/portfolio_stats.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';

class PortfolioPage extends StatelessWidget {
  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark
      ),
      child: SafeArea(
        child: 
        MediaQuery.of(context).orientation == Orientation.portrait ?
          NestedScrollView(
            floatHeaderSlivers: false,
            headerSliverBuilder: ((context, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: 420,
                  floating: true,
                  snap: false,
                  backgroundColor: Colors.white,
                  elevation: 5,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Center(
                      child: Column(
                        children: [
                          Container(
                            color: TabsPage.primaryColor,
                            padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 8)),
                          PortfolioMainSection(),
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
                        PortfolioMainSection(),
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

List<PieChartSectionData> getSections() => PieData.data
    .asMap()
    .map<int, PieChartSectionData>((index, data) {
      final value = PieChartSectionData(
        color: data.color,
        value: data.percent,
        showTitle: false,
        radius: 45,
        titleStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 12),
      );
      return MapEntry(index, value);
    })
    .values
    .toList();

class PieData {
  static List<Data> data = [
    Data(name: 'Crypto', percent: 40, color: TabsPage.primaryColor),
    Data(name: 'Exchange', percent: 10, color: TabsPage.orangeColor),
    Data(name: 'Stock', percent: 50, color: TabsPage.blueColor),
  ];
}

class Data {
  final String name;

  final double percent;

  final Color color;

  Data({required this.name, required this.percent, required this.color});
}
