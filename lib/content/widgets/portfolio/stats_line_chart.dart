import 'package:asset_flutter/content/widgets/portfolio/stats_lc_linechart.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats_lc_toggle.dart';
import 'package:flutter/material.dart';

class PortfolioStatsLineChart extends StatelessWidget {
  final double _topPadding;
  const PortfolioStatsLineChart(this._topPadding);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Analysis",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: StatsLineChartToggleButton(),
              ),
            ],
          ),
          StatsLCLineChart(_topPadding)
        ],
      ),
    );
  }
}