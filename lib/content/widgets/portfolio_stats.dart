import 'package:asset_flutter/content/pages/portfolio_page.dart';
import 'package:asset_flutter/content/widgets/indicator_widget.dart';
import 'package:asset_flutter/content/widgets/portfolio_section_title.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PortfolioStats extends StatelessWidget {
  const PortfolioStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          print("Stats Pressed");
        },
        child: Column(children: [
          const PortfolioSectionTitle("Statistics", "Details>"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IndicatorsWidget(),
              SizedBox(
                height: 180,
                width: MediaQuery.of(context).size.width * 0.485,
                child: PieChart(
                  PieChartData(
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 0,
                    centerSpaceRadius: 30,
                    sections: getSections(),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
