import 'package:asset_flutter/content/providers/wallet/transaction_stats.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats_lc_linechart.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TransactionStatsExpenseChart extends StatelessWidget {
  final String interval;
  const TransactionStatsExpenseChart(this.interval, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionStatsProvider>(builder: (context, value, _) {
      final _stats =  value.item!.dailyStats;

      return _stats.length > 1
      ? SfCartesianChart(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        zoomPanBehavior: ZoomPanBehavior(
          enablePinching: true,
          enablePanning: true,
          enableSelectionZooming: true,
          selectionRectBorderColor: Colors.red,
          selectionRectBorderWidth: 1,
          selectionRectColor: Colors.grey
        ),
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
          isVisible: true,
        ),
        tooltipBehavior: TooltipBehavior(enable: true, canShowMarker: true, format: 'point.y'),
        series: <ChartSeries>[
          SplineAreaSeries<ChartData, String>(
            dataSource: _stats.map(
              (e) => ChartData(e.totalTransaction.toDouble(), DateFormat(
                interval != "yearly"
                ? "dd MMM"
                : "MMM yy"
              ).format(e.date))
            ).toList(),
            markerSettings: const MarkerSettings(isVisible: true),
            xValueMapper: (ChartData data, _) => data.date,
            yValueMapper: (ChartData data, _) => data.stat,
            borderColor: Colors.black,
            borderWidth: 3,
            dataLabelMapper: (_data, index) => _stats[index].currency.getCurrencyFromString() + _data.stat.numToString(),
            dataLabelSettings: DataLabelSettings(
              isVisible: true, 
              color: AppColors().barCardColor,
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors().primaryColor, AppColors().primaryColor.withOpacity(0.5)], 
            )
          ),
        ]
      )
      : Container(
        height: 50,
        width: double.infinity,
        alignment: Alignment.center,
        child: const Text(
          "Not enough data.", 
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16
          )
        ),
      );
    });
  }
}