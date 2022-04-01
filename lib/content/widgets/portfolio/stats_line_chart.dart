import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class PortfolioStatsLineChart extends StatelessWidget {
  const PortfolioStatsLineChart({Key? key}) : super(key: key);

  static const testData = [
    2574.32286371832,
    2853.98107368,
    1259.3123,
    -102.31
  ];

  double getLowestValue() {
    return testData.reduce((value, element) => min(value, element));
  }

  double getMaxValue() {
    return testData.reduce((value, element) => max(value, element));
  }

  List<FlSpot> lineChartMapper() {
    return testData.map((e) => FlSpot(testData.indexOf(e).toDouble(), e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    getLowestValue();
    return Container(
      height: 300,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        color: const Color(0xff020227),
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: LineChart(
            LineChartData(
            minX: 0,
            maxX: 6,
            minY: getLowestValue(),
            maxY: getMaxValue(),
            titlesData: getTitleData(),
            gridData: FlGridData(
              show: true,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: const Color(0xff37434d),
                  strokeWidth: 1,
                );
              },
              drawVerticalLine: true,
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: const Color(0xff37434d),
                  strokeWidth: 1,
                );
              },
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: const Color(0xff37434d), width: 1),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: lineChartMapper(),
                isCurved: true,
                colors: [
                  const Color(0xff23b6e6),
                  const Color(0xff02d39a),
                ],
                barWidth: 5,
                // dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  colors: [
                    const Color(0xff23b6e6),
                    const Color(0xff02d39a),
                  ].map((color) => color.withOpacity(0.3)).toList(),
                ),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }

  getTitleData() => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 45,
          getTextStyles: (value, _) => const TextStyle(
            color: Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '20 Mar';
              case 2:
                return '22 Mar';
              case 4:
                return '24 Mar';
              case 6:
                return 'Today';
            }
            return '';
          },
          margin: 16,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value, _) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            print("Left $value");
            if (value == getLowestValue()) {
              return getLowestValue().toString();
            }
            switch (value.toInt()) {
              case 0:
                return '0';
              case 5:
                return '5';
            }
            return '';
          },
          reservedSize: 35,
          margin: 12,
        ),
      );
}