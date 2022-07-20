import 'package:asset_flutter/content/providers/assets.dart';
import 'package:asset_flutter/content/widgets/portfolio/section_title.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats_indicator.dart';
import 'package:asset_flutter/static/chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PortfolioStats extends StatelessWidget {
  const PortfolioStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final assetStatsProvider = Provider.of<AssetsProvider>(context);
    final assetStats = assetStatsProvider.assetStats;

    return SizedBox(
      child: Column(
        children: [
          const SectionTitle("Investment Distribution",""),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PortfolioStatsIndicator(),
              SizedBox(
                height: MediaQuery.of(context).size.height > 600 ? 180 : 160,
                width: MediaQuery.of(context).size.width * 0.485,
                child: PieChart(
                  PieChartData(
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: 27,
                    sections: assetStats!.currency == ''
                      ? _emptyChartData()
                      : assetStats.convertDataToChart(),
                  ),
                ),
              ),
            ],
          ),
        ]
      )
    );
  }
}

List<PieChartSectionData> _emptyChartData() {
  final list = List<PieChartSectionData>.empty(growable: true);
  for (var i = 0; i < 4; i++) {
    list.add(PieChartSectionData(
      color: ChartAttributes().chartStatsColor[i],
      value: 1,
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
