import 'package:asset_flutter/content/providers/assets.dart';
import 'package:asset_flutter/content/widgets/portfolio/section_title.dart';
import 'package:asset_flutter/static/chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//TODO: Redesign and create bar chart with green/red colors
// https://github.com/imaNNeoFighT/fl_chart/blob/master/example/lib/bar_chart/samples/bar_chart_sample2.dart
// https://www.youtube.com/watch?v=7wUmzYOPQ8w
class PortfolioStatsDistributionChart extends StatelessWidget {
  const PortfolioStatsDistributionChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final assetStatsProvider = Provider.of<AssetsProvider>(context, listen: false);
    final assetStats = assetStatsProvider.assetStats;

    return assetStats == null || assetStats.stockPL == 0 && assetStats.commodityPL == 0 && assetStats.totalPL == 0 && assetStats.cryptoPL == 0 && assetStats.exchangePL == 0
      ? Container()
      : Column(
        children: [
          SectionTitle("Profit/Loss Distribution", ""),
          Container(
            height: 250,
            margin: const EdgeInsets.only(top: 8, bottom: 12),
            width: MediaQuery.of(context).size.width * 0.75,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.center,
                barTouchData: BarTouchData(enabled: true),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value){
                    return FlLine(
                      strokeWidth: value == 0 ? 0.4 : 0,
                      color: Colors.black
                    );
                  }
                ),
                barGroups: assetStats.convertDataToBarChart(),
                groupsSpace: 40,
                titlesData: FlTitlesData(
                  topTitles: SideTitles(
                    showTitles: true,
                    getTextStyles: (context, value) => TextStyle(color: ChartAttributes().chartStatsColor[value.toInt()], fontSize: 12),
                    getTitles: (id) => ChartAttributes().chartStatsText[id.toInt()],
                  ),
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTitles: (id) => "",
                  ),
                  leftTitles: SideTitles(
                    showTitles: false
                  ),
                  rightTitles: SideTitles(
                    showTitles: false,
                  ),
                )
              )
            ),
          ),
        ],
      );
  }
}