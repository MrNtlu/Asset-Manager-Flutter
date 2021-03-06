import 'package:asset_flutter/static/chart.dart';
import 'package:flutter/material.dart';

class PortfolioStatsIndicator extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < 4; i++)
        Container(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: <Widget>[
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ChartAttributes().chartStatsColor[i],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                ChartAttributes().chartStatsText[i],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ChartAttributes().chartStatsColor[i],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}