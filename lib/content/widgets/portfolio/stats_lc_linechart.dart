import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/content/pages/portfolio/portfolio_fullscreen_stats_page.dart';
import 'package:asset_flutter/content/providers/portfolio/daily_stats.dart';
import 'package:asset_flutter/content/providers/common/stats_toggle_state.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats_lc_premium.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatsLCLineChart extends StatefulWidget{
  final double _topPadding;
  const StatsLCLineChart(this._topPadding, {Key? key}) : super(key: key);

  @override
  State<StatsLCLineChart> createState() => _StatsLCLineChartState();
}

class _StatsLCLineChartState extends State<StatsLCLineChart> {
  late List<double> plList;
  late List<double> assetList;
  late List<DateTime> dateList;

  ViewState _state = ViewState.init;
  late final DailyStatsProvider _dailyStatsProvider;
  late final StatsToggleSelectionStateProvider _statsSelectionProvider;

  void _getDailyStats({interval = "weekly"}) {
    setState(() {
      _state = ViewState.loading;
    });

    _dailyStatsProvider.getDailyStats(interval: interval).then((response){
      if (_state != ViewState.disposed) { 
        setState(() {
          _state = (response.message != "" || response.data == null)
            ? ViewState.error
            : (
              response.data!.totalPL.isEmpty || response.data!.totalPL.length <= 2
                ? ViewState.empty
                : ViewState.done
            );

            if (_state == ViewState.done) {
              plList = response.data!.totalPL.map((e) => e.toDouble().revertValue()).toList();
              assetList = response.data!.totalAssets.map((e) => e.toDouble()).toList();
              dateList = response.data!.dates;
            }
        });
      }
    });
  }

  List<ChartData> _lineChartMapper({bool isProfit = true}) {
    final List<double> tempList = isProfit ? plList : assetList;
    final String formatType = (isProfit ? plList.length : assetList.length) <= 15
      ? 'dd MMM'
      : (isProfit ? plList.length : assetList.length) <= 45 ? 'dd MMM yy' : 'MMM yy';
    List<ChartData> chartList = [];
    for (var i = 0; i < tempList.length; i++) {
      chartList.add(
        ChartData(double.parse(tempList[i].toStringAsFixed(2)), DateFormat(formatType).format(dateList[i]))
      );
    }
    return chartList;
  }

  void _statsSelectionListener() {
    if (_state != ViewState.disposed && _statsSelectionProvider.interval != null) {
      setState(() {
        _getDailyStats(interval: _statsSelectionProvider.interval);
      });
    }
  }

  @override
  void dispose() {
    _statsSelectionProvider.removeListener(_statsSelectionListener);
    _state = ViewState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ViewState.init) {
      _dailyStatsProvider = Provider.of<DailyStatsProvider>(context);
      _getDailyStats();

      _statsSelectionProvider = Provider.of<StatsToggleSelectionStateProvider>(context);
      _statsSelectionProvider.addListener(_statsSelectionListener);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: AppColors().barCardColor,
          child: Column(
            children: [
              SizedBox(
                height: 320,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 2),
                  child: _portraitBody("Total Assets", isProfit: false),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 2),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return PortfolioFullscreenStatsPage(_lineChartMapper(isProfit: false), "Total Assets", _dailyStatsProvider.item!.currency);
                    })),
                    child: const Text(
                      "Click to view fullscreen",
                      style: TextStyle(
                        fontSize: 12
                      ),
                    )
                  ),
                ),
              )
            ],
          ),
        ),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: AppColors().barCardColor,
          child: Column(
            children: [
              SizedBox(
                height: 320,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 2),
                  child: _portraitBody("Profit/Loss"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 2),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return PortfolioFullscreenStatsPage(_lineChartMapper(isProfit: true), "Profit/Loss", _dailyStatsProvider.item!.currency);
                    })),
                    child: const Text(
                      "Click to view fullscreen",
                      style: TextStyle(
                        fontSize: 12
                      ),
                    )
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _portraitBody(String title, {bool isProfit = true}) {
    switch (_state) {
      case ViewState.loading:
        return const LoadingView("Fetcing stats", textColor: Colors.white);
      case ViewState.error:
        return StatsLineChartPremiumView(widget._topPadding);
      case ViewState.empty:
        return Center(
          child: Text(
            "Not enough data for ${
              _statsSelectionProvider.interval == null || _statsSelectionProvider.interval == 'weekly' 
                ? '7 days'
                : (
                  _statsSelectionProvider.interval == 'monthly'
                    ? '30 days'
                    : '3 months'
                )
            }", 
            style: const TextStyle(color: Colors.white)
          ),
        );
      case ViewState.done:
        return SfCartesianChart(
          title: ChartTitle(
            text: "$title${
                _dailyStatsProvider.item != null && _dailyStatsProvider.item!.currency != ''
              ? '('+_dailyStatsProvider.item!.currency+')'
              : ''
            }",
            alignment: ChartAlignment.near,
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold
            )
          ),
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
            majorGridLines: const MajorGridLines(width: 0),
            labelPlacement: LabelPlacement.onTicks,
            labelStyle: const TextStyle(
              color: Colors.white
            ),
            labelIntersectAction: AxisLabelIntersectAction.rotate45,
            interval: _statsSelectionProvider.interval == null || _statsSelectionProvider.interval == 'weekly' 
                ? 1
                : (_statsSelectionProvider.interval == 'monthly' ? 2 : 3)
          ),
          primaryYAxis: NumericAxis(
            axisLine: const AxisLine(width: 0),
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            majorTickLines: const MajorTickLines(size: 0),
            isVisible: false,
          ),
          tooltipBehavior: TooltipBehavior(enable: true, canShowMarker: true, format: 'point.x - point.y ${_dailyStatsProvider.item!.currency}'),
          series: [
            SplineSeries<ChartData, String>(
              name: isProfit ? "Profit/Loss" : "Total Assets",
              color: AppColors().accentColor,
              dataSource: _lineChartMapper(isProfit: isProfit),
              markerSettings: const MarkerSettings(isVisible: true),
              xValueMapper: (ChartData data, _) => data.date,
              yValueMapper: (ChartData data, _) => data.stat,
            )
          ],
        );
      default:
        return const LoadingView("Loading", textColor: Colors.white);
    }
  }

  getTitleData({bool isProfit = true}) => FlTitlesData(
    show: true,
    rightTitles: SideTitles(showTitles: false),
    topTitles: SideTitles(showTitles: false),
    leftTitles: SideTitles(showTitles: false),
    bottomTitles: SideTitles(
      showTitles: true,
      reservedSize: 20,
      getTextStyles: (value, _) => const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 10,
      ),
      getTitles: (value) {
        var listLength = isProfit ? plList.length : assetList.length;
        final String formatType = (isProfit ? plList.length : assetList.length) <= 75 ? 'dd MM' : 'MMM yy';
        if(value < 1 || (listLength < 75 && value == listLength - 1)) {
          return '';
        }

        if((listLength <= 7 && value % 1 == 0) || listLength > 7){
          return DateFormat(formatType).format(dateList[value.toInt()]);
        } else {
          return '';
        }
      },
      margin: 8,
    ),
  );
}

class ChartData {
  final double stat;
  final String date;

  const ChartData(this.stat, this.date);
}