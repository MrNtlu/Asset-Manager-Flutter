import 'package:asset_flutter/content/widgets/portfolio/stats_lc_linechart.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PortfolioFullscreenStatsPage extends StatelessWidget {
  final List<ChartData> _chartData;
  final String _title;
  final String _currency;
  const PortfolioFullscreenStatsPage(this._chartData, this._title, this._currency, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().barCardColor,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context), 
                    icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white,)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    "$_title($_currency)",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: SfCartesianChart(
                margin: const EdgeInsets.fromLTRB(8, 24, 8, 8),
                zoomPanBehavior: ZoomPanBehavior(
                  enablePinching: true,
                  enablePanning: true,
                  enableDoubleTapZooming: true,
                  enableSelectionZooming: true,
                  selectionRectBorderColor: Colors.red,
                  selectionRectBorderWidth: 1,
                  selectionRectColor: Colors.grey
                ),
                primaryXAxis: CategoryAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  labelPlacement: LabelPlacement.onTicks,
                  labelStyle: const TextStyle(
                    color: Colors.white
                  )
                ),
                primaryYAxis: NumericAxis(
                  axisLine: const AxisLine(width: 0),
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  majorTickLines: const MajorTickLines(size: 0),
                  isVisible: true,
                  labelStyle: const TextStyle(
                    color: Colors.white
                  )
                ),
                tooltipBehavior: TooltipBehavior(
                  enable: true, 
                  canShowMarker: true, 
                  format: 'point.x - point.y $_currency',
                ),
                series: [
                  SplineSeries<ChartData, String>(
                    name: _title,
                    color: AppColors().accentColor,
                    dataSource: _chartData,
                    markerSettings: const MarkerSettings(isVisible: true),
                    dataLabelSettings: const DataLabelSettings(isVisible: true, color: Colors.white),
                    xValueMapper: (ChartData data, _) => data.date,
                    yValueMapper: (ChartData data, _) => data.stat,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
