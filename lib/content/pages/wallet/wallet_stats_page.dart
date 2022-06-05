import 'package:asset_flutter/content/providers/wallet/transaction.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats_lc_linechart.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WalletStatsPage extends StatefulWidget {
  const WalletStatsPage();

  @override
  State<WalletStatsPage> createState() => _WalletStatsPageState();
}

class _WalletStatsPageState extends State<WalletStatsPage> {
  final List<bool> isSelected = [false, true, false];

  final List<ChartData> chartData = [
    ChartData(26, DateTime(2022, 05, 30).toString()),
    ChartData(458, DateTime(2022, 05, 31).toString()),
    ChartData(302.12, DateTime(2022, 06, 01).toString()),
    ChartData(12, DateTime(2022, 06, 02).toString()),
    ChartData(1002.1, DateTime(2022, 06, 03).toString()),
    ChartData(1248.0, DateTime.now().toString()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context), 
                        icon: const Icon(Icons.arrow_back_ios_new_rounded)
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ToggleButtons(
                          borderWidth: 0,
                          selectedColor: Colors.transparent,
                          borderColor: Colors.transparent,
                          fillColor: Colors.transparent,
                          selectedBorderColor: Colors.transparent,
                          disabledBorderColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          children: [
                            _toggleButton("Week", 0),
                            _toggleButton("Month", 1),
                            _toggleButton("Year", 2),
                          ],
                          isSelected: isSelected,
                          onPressed: (int newIndex) {
                            isSelected[isSelected.indexOf(true)] = false;
                            setState(() {
                              isSelected[newIndex] = true;
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        color: AppColors().redColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Expense",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: AutoSizeText(
                                  "\$ 23492",
                                  maxLines: 1,
                                  minFontSize: 16,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        color: AppColors().greenColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Income",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: AutoSizeText(
                                  "\$ 1000",
                                  maxLines: 1,
                                  minFontSize: 16,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(12, 24, 12, 4),
                child: const Text(
                  "Category Distribution",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SfCircularChart(
                legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap, position: LegendPosition.auto), 
                series: <CircularSeries>[
                  PieSeries<PieChartData, String>(
                    dataSource: Category.values.map((e) {
                      return PieChartData("${e.name[0].toUpperCase()}${e.name.substring(1, e.name.length)}", e.value.toDouble(), e.iconColor);
                    }).toList(),
                    pointColorMapper:(PieChartData data, _) => data.color,
                    xValueMapper: (PieChartData data, _) => data.x,
                    yValueMapper: (PieChartData data, _) => data.y,
                    dataLabelSettings: const DataLabelSettings(isVisible : true,useSeriesColor: true),
                    radius: '75%'
                  )
                ]
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 16),
                child: const Text(
                  "Expenses",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                child: SfCartesianChart(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  primaryXAxis: CategoryAxis(
                    majorGridLines: const MajorGridLines(width: 0.5),
                    labelPlacement: LabelPlacement.onTicks,
                    labelStyle: const TextStyle(
                      color: Colors.black
                    ),
                    labelIntersectAction: AxisLabelIntersectAction.rotate45,
                  ),
                  primaryYAxis: NumericAxis(
                    axisLine: const AxisLine(width: 0),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    majorTickLines: const MajorTickLines(size: 0),
                    isVisible: false,
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true, canShowMarker: true, format: 'point.y'),
                  series: <ChartSeries>[
                    SplineAreaSeries<ChartData, String>(
                      dataSource: chartData,
                      markerSettings: const MarkerSettings(isVisible: true),
                      xValueMapper: (ChartData data, _) => DateFormat("dd MMM").format(DateTime.parse(data.date)),
                      yValueMapper: (ChartData data, _) => data.stat,
                      borderColor: Colors.black,
                      borderWidth: 3,
                      dataLabelSettings: DataLabelSettings(isVisible: true, color: AppColors().barCardColor),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppColors().primaryColor, AppColors().primaryColor.withOpacity(0.5)], 
                      )
                    ),
                  ]
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  Widget _toggleButton(String _title, int index) {
    if (isSelected[index]) {
      return SizedBox(
        width: 70,
        child: Card(
          color: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _toggleText(_title, isSelected[index]),
          ),
        ),
      );
    }
    return SizedBox(
      width: 70,
      child: _toggleText(_title, isSelected[index])
    );
  }

  Widget _toggleText(String _title, bool _isSelected) => Text(
    _title, 
    textAlign: TextAlign.center,
    style: TextStyle(
      color: _isSelected ? Colors.white : Colors.black54,
      fontSize: 14,
      fontWeight: _isSelected ? FontWeight.bold : FontWeight.normal
    )
  );
}

class PieChartData {
  PieChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}