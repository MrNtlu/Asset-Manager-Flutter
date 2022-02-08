import 'package:asset_flutter/content/pages/portfolio/portfolio_page.dart';
import 'package:asset_flutter/static/chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PortfolioStatsDistributionChart extends StatelessWidget {
  const PortfolioStatsDistributionChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      margin: const EdgeInsets.only(top: 8),
      width: MediaQuery.of(context).size.width * 0.7,
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
          barGroups: TestData.testAssetStatsData.convertDataToBarChart(),
          groupsSpace: 35,
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
    );
  }
}