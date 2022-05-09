import 'package:asset_flutter/content/widgets/portfolio/portfolio.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats_detailed_table.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats_distribution_chart.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats_line_chart.dart';
import 'package:flutter/material.dart';

class PortfolioStatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppBar appBar = AppBar(
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      title: const Text(
        'Statistics', 
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
      ),
      backgroundColor: Colors.white,
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: SafeArea(
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
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