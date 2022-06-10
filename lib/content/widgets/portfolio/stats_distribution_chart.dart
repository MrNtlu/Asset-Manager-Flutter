import 'package:asset_flutter/content/providers/assets.dart';
import 'package:asset_flutter/content/widgets/portfolio/section_title.dart';
import 'package:asset_flutter/static/chart.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PortfolioStatsDistributionChart extends StatelessWidget {
  const PortfolioStatsDistributionChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final assetStatsProvider = Provider.of<AssetsProvider>(context, listen: false);
    final assetStats = assetStatsProvider.assetStats;
    final _textColor = Theme.of(context).colorScheme.bgTextColor;

    return assetStats == null || assetStats.stockPL == 0 && assetStats.commodityPL == 0 && assetStats.totalPL == 0 && assetStats.cryptoPL == 0 && assetStats.exchangePL == 0
      ? Container()
      : Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: SectionTitle("Profit/Loss Distribution", ""),
          ),
          Container(
            height: 250,
            margin: const EdgeInsets.only(top: 12, bottom: 4),
            child: SfCartesianChart(
              legend: Legend(title: LegendTitle(text: "Profit/Loss")),
              primaryXAxis: CategoryAxis(
                labelStyle: TextStyle(
                  color: _textColor,
                  fontWeight: FontWeight.bold
                )
              ),
              primaryYAxis: NumericAxis(
                labelStyle: TextStyle(
                  color: _textColor,
                )
              ),
              tooltipBehavior: TooltipBehavior(
                enable: true,
                header: "P/L",
                canShowMarker: true,
                format: '${assetStats.currency.getCurrencyFromString()} point.y'
              ),
              series: <ChartSeries<double, String>>[
                ColumnSeries<double, String>(
                  dataSource: assetStats.convertDataToDouble(),
                  xValueMapper: (double data, index) => ChartAttributes().chartStatsText[index],
                  yValueMapper: (double data, _) => data,
                  pointColorMapper: (value, index) => assetStats.convertDataToTitle()[index],
                  spacing: 0.3,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  )
                )
              ]
            )
          ),
        ],
      );
  }
}