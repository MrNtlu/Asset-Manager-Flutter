import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/content/providers/portfolio/daily_stats.dart';
import 'package:asset_flutter/content/providers/common/stats_toggle_state.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats_lc_premium.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:provider/provider.dart';

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

  double _getLowestValue({bool isProfit = true}) {
    return isProfit 
      ? plList.reduce((value, element) => min(value, element))
      : assetList.reduce((value, element) => min(value, element));
  }

  double _getMaxValue({bool isProfit = true}) {
    return isProfit
      ? plList.reduce((value, element) => max(value, element))
      : assetList.reduce((value, element) => max(value, element));
  }

  List<FlSpot> _lineChartMapper({bool isProfit = true}) {
    final List<double> tempList = isProfit ? plList : assetList;
    List<FlSpot> flSpotList = [];
    for (var i = 0; i < tempList.length; i++) {
      flSpotList.add(
        FlSpot(i.toDouble(), double.parse(tempList[i].toStringAsFixed(2)))
      );
    }

    return flSpotList;
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
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: _chartHeaderText("Total Assets"),
              ),
              SizedBox(
                height: 320,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(6, 18, 6, 4),
                  child: _portraitBody(isProfit: false),
                ),
              ),
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
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: _chartHeaderText("Profit/Loss")
              ),
              SizedBox(
                height: 320,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(6, 18, 6, 4),
                  child: _portraitBody(),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Text _chartHeaderText(String title) => Text(
    "$title${
        _dailyStatsProvider.item != null && _dailyStatsProvider.item!.currency != ''
      ? '('+_dailyStatsProvider.item!.currency+')'
      : ''
    }",
    style: const TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.bold
    )
  );

  Widget _portraitBody({bool isProfit = true}) {
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
        return LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                fitInsideHorizontally: true
              )
            ),
            minX: 0,
            maxX: isProfit ? (plList.length - 1) : (assetList.length - 1),
            minY: _getLowestValue(isProfit: isProfit),
            maxY: _getMaxValue(isProfit: isProfit),
            titlesData: getTitleData(isProfit: isProfit),
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
                dotData: FlDotData(show: isProfit ? plList.length <= 75 : assetList.length <= 75),
                spots: _lineChartMapper(isProfit: isProfit),
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