import 'dart:io';

import 'package:asset_flutter/content/pages/market/markets_page.dart';
import 'package:asset_flutter/content/widgets/portfolio/portfolio.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats_distribution_chart.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats_line_chart.dart';
import 'package:flutter/material.dart';

class PortfolioStatsPage extends StatelessWidget {
  const PortfolioStatsPage();

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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context), 
                            icon: Icon(Platform.isIOS || Platform.isMacOS ? Icons.arrow_back_ios_new_rounded : Icons.arrow_back_rounded)
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const MarketsPage())
                          ), 
                            icon: const ImageIcon(AssetImage("assets/images/markets.png"))
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Portfolio(isDetailed: true),
                  const PortfolioStats(),
                  const Divider(),
                  PortfolioStatsLineChart(MediaQuery.of(context).viewPadding.top),
                  const Divider(),
                  const PortfolioStatsDistributionChart(),
                  const SizedBox(height: 8)
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }
}