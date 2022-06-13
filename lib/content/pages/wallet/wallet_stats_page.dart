import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/content/pages/portfolio/portfolio_fullscreen_stats_page.dart';
import 'package:asset_flutter/content/providers/wallet/transaction_stats.dart';
import 'package:asset_flutter/content/providers/wallet/transaction_stats_toggle.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats_lc_linechart.dart';
import 'package:asset_flutter/content/widgets/wallet/transaction_stats_toggle.dart';
import 'package:asset_flutter/content/widgets/wallet/ts_category_distribution.dart';
import 'package:asset_flutter/content/widgets/wallet/ts_expense_chart.dart';
import 'package:asset_flutter/content/widgets/wallet/ts_total_cards.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WalletStatsPage extends StatefulWidget {
  const WalletStatsPage();

  @override
  State<WalletStatsPage> createState() => _WalletStatsPageState();
}

class _WalletStatsPageState extends State<WalletStatsPage> {
  ViewState _state = ViewState.init;
  String interval = "monthly";
  String? error;

  late final TransactionStatsProvider _provider;
  late final TransactionStatsToggleProvider _toggleProvider;
  
  void _getTransactionStats() {
    setState(() {
      _state = ViewState.loading;
    });

    _provider.getTransactionStats(interval: interval).then((response) {
      if (_state != ViewState.disposed) {
        setState(() {
          _state = response.error != null
          ? ViewState.error
          : ViewState.done;
        });
      }
    });
  }

  void _onIntervalChanged() {
    if (_state != ViewState.disposed) {
      interval = _toggleProvider.selectedInterval ?? "monthly";
      _getTransactionStats();
    }
  }

  @override
  void dispose() {
    _toggleProvider.removeListener(_onIntervalChanged);
    _provider.dispose();
    _state = ViewState.disposed;
    super.dispose();
  }

  @override
  void initState() {
    _provider = TransactionStatsProvider();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_state == ViewState.init) {
      _toggleProvider = Provider.of<TransactionStatsToggleProvider>(context);
      _toggleProvider.addListener(_onIntervalChanged); 
      _getTransactionStats();
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ChangeNotifierProvider.value(
        value: _provider,
        child: SafeArea(
          child: _body(),
        ),
      )
    );
  }

  Widget _body() {
    switch (_state) {
      case ViewState.done:
        return SingleChildScrollView(
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
                        child: TransactionStatsToggle(interval: interval),
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
                  children: const [
                    Expanded(
                      child: TransactionStatsTotalCards(true),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TransactionStatsTotalCards(false),
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
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              const TransactionStatsCategoryDistribution(),
              Container(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 16),
                child: Row(
                  children: [
                    const Text(
                      "Expenses",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    if (_provider.item!.dailyStats.length > 1)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                              return PortfolioFullscreenStatsPage(
                                _provider.item!.dailyStats.map(
                                  (e) => ChartData(e.totalTransaction.toDouble(), DateFormat(
                                    interval != "yearly"
                                    ? "dd MMM"
                                    : "MMM yy"
                                  ).format(e.date))
                                ).toList(), 
                                "Expenses",
                                _provider.item!.dailyStats[0].currency
                              );
                            })),
                            child: const Text(
                              "Click to view fullscreen",
                              style: TextStyle(
                                fontSize: 12
                              ),
                            )
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                child: TransactionStatsExpenseChart(interval),
              )
            ],
          ),
        );
      case ViewState.error:
        return ErrorView(error ?? "Unknown error.", _getTransactionStats);
      case ViewState.loading:
        return const LoadingView("Getting statistics");
      default:
        return const LoadingView("Loading");
    }
  }
}