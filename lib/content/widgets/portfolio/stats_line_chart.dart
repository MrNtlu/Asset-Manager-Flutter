import 'package:asset_flutter/content/widgets/portfolio/stats_lc_linechart.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats_lc_toggle.dart';
import 'package:flutter/material.dart';

//TODO: Make seperate PL & TotalAssets and put currency information on top
class PortfolioStatsLineChart extends StatelessWidget {
  const PortfolioStatsLineChart();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "Daily Stats",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: StatsLineChartToggleButton(),
              ),
            ],
          ),
          SizedBox(
            height: 320,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: const Color(0xff020227),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 18, 6, 4),
                child: StatsLCLineChart(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}