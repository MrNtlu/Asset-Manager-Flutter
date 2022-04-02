import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/content/providers/portfolio/daily_stats.dart';
import 'package:asset_flutter/content/providers/portfolio/stats_toggle_state.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:provider/provider.dart';

class StatsLCLineChart extends StatefulWidget{
  StatsLCLineChart({Key? key}) : super(key: key);

  @override
  State<StatsLCLineChart> createState() => _StatsLCLineChartState();
}

class _StatsLCLineChartState extends State<StatsLCLineChart> {
  late List<double> plList;

  ViewState _state = ViewState.init;
  String? _error;
  late final DailyStatsProvider _dailyStatsProvider;
  late final StatsToggleSelectionStateProvider _statsSelectionProvider;

  void _getDailyStats({interval = "weekly"}) {
    setState(() {
      _state = ViewState.loading;
    });

    _dailyStatsProvider.getDailyStats(interval: interval).then((response){
      _error = response.message != "" ? response.message : null;
      if (_state != ViewState.disposed) { 
        setState(() {
          _state = (response.message != "" || response.data == null)
            ? ViewState.error
            : (
              response.data!.totalPL.isEmpty
                ? ViewState.empty
                : ViewState.done
            );

            if (_state == ViewState.done) {
              plList = response.data!.totalPL.map((e) => (e as double).revertValue()).toList();
            }
        });
      }
    });
  }

  double _getLowestValue() {
    return plList.reduce((value, element) => min(value, element));
  }

  double _getMaxValue() {
    return plList.reduce((value, element) => max(value, element));
  }

  List<FlSpot> _lineChartMapper() {
    return plList.map((e) => FlSpot(plList.indexOf(e).toDouble(), double.parse(e.toStringAsFixed(2)))).toList();
  }

  @override
  void dispose() {
    _state = ViewState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ViewState.init) {
      _dailyStatsProvider = Provider.of<DailyStatsProvider>(context);
      _getDailyStats();

      _statsSelectionProvider = Provider.of<StatsToggleSelectionStateProvider>(context);
      _statsSelectionProvider.addListener(() {
        if (_state != ViewState.disposed && _statsSelectionProvider.interval != null) {
          setState(() {
            _getDailyStats(interval: _statsSelectionProvider.interval);
          });
        }
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _portraitBody();
  }

  Widget _portraitBody() {
    switch (_state) {
      case ViewState.loading:
        return const LoadingView("Fetcing stats", textColor: Colors.white);
      case ViewState.error:
        return ErrorView(_error ?? "Unknown error!", _getDailyStats);
      case ViewState.done:
        return LineChart(
          LineChartData(
            lineTouchData: LineTouchData(enabled: true),
            minX: 0,
            maxX: (plList.length -1),
            minY: _getLowestValue(),
            maxY: _getMaxValue(),
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
                dotData: FlDotData(show: plList.length <= 75),
                spots: _lineChartMapper(),
                curveSmoothness: 0.25,
                isCurved: true,
                colors: [
                  const Color(0xff23b6e6),
                  const Color(0xff02d39a),
                ],
                barWidth: 2,
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
        );
      default:
        return const LoadingView("Loading", textColor: Colors.white);
    }
  }

  getTitleData() => FlTitlesData(
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
        if (value < 1) {
          return '';
        } else if (plList.length < 75 && value == plList.length - 1) {
          return '';
        }

        if (plList.length <= 10) {
          return getBottomTitleList("weekly")[value.toInt()];
        } else if (plList.length > 10 && plList.length <= 20 && value % 2 == 0) {
          return getBottomTitleList("monthly")[value.toInt()];
        } else if (plList.length > 20 && plList.length <= 24 && value % 4 == 2) {
          return getBottomTitleList("monthly")[value.toInt()];
        } else if (plList.length > 24 && plList.length <= 45 && value % 5 == 0) {
          return getBottomTitleList("monthly")[value.toInt()];
        } else if (plList.length > 45 && plList.length <= 75 && value % 10 == 0) {
          return getBottomTitleList("monthly")[value.toInt()];
        } else if (plList.length > 75 && plList.length <= 90 && value % 30 == 0) {
          return getBottomTitleList("3monthly")[value.toInt()];
        }
        return '';
      },
      margin: 8,
    ),
  );

  List<String> getBottomTitleList(String interval) {
    final List<String> titleList = [];
    final String formatType = plList.length <= 75 ? 'dd MM' : 'MMM yy';

    for (var i = 0; i < plList.length; i++) {
      late String title;
      if (i == 0) {
        title = DateFormat(formatType).format(DateTime.now());
      } else { 
        var date = DateTime.now().add(Duration(days: -i));
        title = DateFormat(formatType).format(date);
      }
      titleList.insert(0, title);
    }
    return titleList;
  }
}