import 'package:asset_flutter/content/widgets/portfolio/portfolio.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats_detailed_table.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats_distribution_chart.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats_line_chart.dart';
import 'package:flutter/material.dart';

class PortfolioStatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context), 
                      icon: const Icon(Icons.arrow_back_ios_new_rounded)
                    ),
                  ),
                  const Portfolio(isDetailed: true),
                  const PortfolioStats(true),
                  PortfolioStatsLineChart(MediaQuery.of(context).viewPadding.top),
                  const PortfolioStatsDistributionChart(),
                  const PortfolioStatsDetailedTable(),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }
}