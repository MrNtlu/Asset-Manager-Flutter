import 'package:asset_flutter/content/widgets/portfolio/stats_lc_linechart.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/utils/extensions.dart';
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
                    icon: const Icon(Icons.arrow_back_ios_rounded)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: MediaQuery.of(context).orientation == Orientation.landscape 
                    ? Text(
                    "$_title($_currency)",
                    style: const TextStyle(
                    ),
                  )
                  : const Text(
                    "Landscape mode recommended.",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold
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
                ),
                primaryYAxis: NumericAxis(
                  axisLine: const AxisLine(width: 0),
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  majorTickLines: const MajorTickLines(size: 0),
                  isVisible: true,
                ),
                tooltipBehavior: TooltipBehavior(
                  enable: true, 
                  canShowMarker: true, 
                  format: 'point.x - ${_currency.getCurrencyFromString()} point.y',
                ),
                series: [
                  SplineAreaSeries<ChartData, String>(
                    name: _title,
                    borderColor: Theme.of(context).colorScheme.bgTextColor,
                    borderWidth: 3,
                    dataSource: _chartData,
                    markerSettings: MarkerSettings(isVisible: true, color: Theme.of(context).colorScheme.bgTextColor),
                    dataLabelMapper: (_data, index) => _currency.getCurrencyFromString() + _data.stat.numToString(),
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true, 
                      color: Theme.of(context).colorScheme.bgTextColor
                    ),
                    xValueMapper: (ChartData data, _) => data.date,
                    yValueMapper: (ChartData data, _) => data.stat,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors().primaryColor, AppColors().primaryColor.withOpacity(0.5)], 
                    )
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
