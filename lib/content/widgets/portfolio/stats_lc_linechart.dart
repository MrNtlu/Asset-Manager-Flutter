import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/content/pages/portfolio/portfolio_fullscreen_stats_page.dart';
import 'package:asset_flutter/content/providers/portfolio/daily_stats.dart';
import 'package:asset_flutter/content/providers/common/stats_toggle_state.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats_lc_premium.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
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
              response.data!.totalPL.isEmpty || response.data!.totalPL.length < 2
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
    final String interval = _statsSelectionProvider.interval ?? "weekly";
    final String formatType = interval != "yearly"
      ? 'dd MMM'
      : 'MMM yy';
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
    switch (_state) {
      case ViewState.loading:
        return const SizedBox(
          height: 150,
          child: LoadingView("Fetcing stats", textColor: Colors.black)
        );
      case ViewState.error:
        return SizedBox(
          height: 250,
          child: StatsLineChartPremiumView(widget._topPadding, textColor: Theme.of(context).colorScheme.bgTextColor)
        );
      case ViewState.empty:
        return const SizedBox(
          height: 150,
          child: Center(
            child: Text(
              "Not enough data yet", 
            ),
          ),
        );
      case ViewState.done:
        return _bodySkeleton();
      default:
        return const LoadingView("Loading", textColor: Colors.black);
    }
  }

  Widget _bodySkeleton() => Column(
    children: [
      Column(
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
      Column(
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
    ],
  );

  Widget _portraitBody(String title, {bool isProfit = true}) => SfCartesianChart(
    title: ChartTitle(
      text: "$title${
          _dailyStatsProvider.item != null && _dailyStatsProvider.item!.currency != ''
        ? '('+_dailyStatsProvider.item!.currency+')'
        : ''
      }",
      alignment: ChartAlignment.near,
      textStyle: TextStyle(
        color: Theme.of(context).colorScheme.bgTextColor,
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
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.bgTextColor,
        fontWeight: FontWeight.bold
      ),
      labelIntersectAction: AxisLabelIntersectAction.rotate45,
      interval: (_statsSelectionProvider.interval ?? "weekly") != "monthly"
      ? 1
      : 2
    ),
    primaryYAxis: NumericAxis(
      axisLine: const AxisLine(width: 0),
      edgeLabelPlacement: EdgeLabelPlacement.shift,
      majorTickLines: const MajorTickLines(size: 0),
      isVisible: false,
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.bgTextColor,
      ),
    ),
    tooltipBehavior: TooltipBehavior(enable: true, canShowMarker: true, format: 'point.x - ${_dailyStatsProvider.item!.currency.getCurrencyFromString()} point.y'),
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
}

class ChartData {
  final double stat;
  final String date;

  const ChartData(this.stat, this.date);
}