import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:asset_flutter/content/widgets/portfolio/portfolio.dart';
import 'package:asset_flutter/content/widgets/portfolio/section_title.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats_detailed_table.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats_distribution_chart.dart';
import 'package:flutter/material.dart';

class PortfolioStatsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final AppBar appBar = AppBar(
      title: const Text('Statistics'),
      backgroundColor: TabsPage.primaryLightishColor,
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
                children: const [
                  Portfolio(isDetailed: true),
                  PortfolioStats(true),
                  SectionTitle("Profit/Loss Distribution", ""),
                  PortfolioStatsDistributionChart(),
                  PortfolioStatsDetailedTable(),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }
}