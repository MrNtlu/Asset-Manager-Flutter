import 'package:asset_flutter/content/widgets/portfolio/portfolio.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats.dart';
import 'package:flutter/material.dart';

class PortfolioStatsHeader extends StatelessWidget {

  const PortfolioStatsHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Portfolio(),
        PortfolioStats(false),
      ],
    );
  }
}
