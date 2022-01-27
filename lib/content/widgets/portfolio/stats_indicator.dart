import 'package:asset_flutter/content/pages/portfolio/portfolio_page.dart';
import 'package:flutter/material.dart';

class PortfolioStatsIndicator extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < 3; i++)
        Container(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: <Widget>[
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: TestData.testChartStatsColor[i],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                TestData.testChartStatsText[i],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: TestData.testChartStatsColor[i],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}