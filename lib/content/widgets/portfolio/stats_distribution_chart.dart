import 'package:asset_flutter/content/providers/assets.dart';
import 'package:asset_flutter/content/widgets/portfolio/section_title.dart';
import 'package:asset_flutter/static/chart.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: SectionTitle("Profit/Loss Distribution", ""),
          ),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: AppColors().barCardColor,
            child: Container(
              height: 250,
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.center,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      fitInsideHorizontally: true,
                    )
                  ),
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
                  groupsSpace: 45,
                  titlesData: FlTitlesData(
                    topTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) => const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      getTitles: (id) => ChartAttributes().chartStatsText[id.toInt()],
                    ),
                    bottomTitles: SideTitles(
                      showTitles: false,
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
          ),
        ],
      );
  }
}