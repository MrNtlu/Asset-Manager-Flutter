import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/content/pages/wallet/wallet_stats_page.dart';
import 'package:asset_flutter/content/providers/wallet/transaction_state.dart';
import 'package:asset_flutter/content/providers/wallet/transaction_total_stat.dart';
import 'package:asset_flutter/content/providers/wallet/wallet_state.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalletStats extends StatefulWidget {
  const WalletStats({Key? key}) : super(key: key);

  @override
  State<WalletStats> createState() => _WalletStatsState();
}

class _WalletStatsState extends State<WalletStats> {
  ViewState _state = ViewState.init;
  late final TransactionTotalStatsProvider _totalStatsProvider;
  late final WalletStateProvider _walletStateProvider;
  late final TransactionStateProvider _transactionsStateProvider;
  final List<bool> isSelected = [true, false];

  void _getTotalStats() {
    setState(() {
      _state = ViewState.loading;
    });

    _totalStatsProvider.getDailyStats(interval: isSelected[0] ? "month" : "day").then((response) {
      if (_state != ViewState.disposed) {
        setState(() {
          _state = (response.error != null || response.data == null)
            ? ViewState.error
            : (
              response.data!.currency.isEmpty || response.data!.currency == ''
                ? ViewState.empty
                : ViewState.done
            );
        });
      }
    });
  }

  void _walletStateListener() {
    if (_state != ListState.disposed) {
      _getTotalStats();
    }
  }

  void _transactionStateListener() {
    if (_state != ListState.disposed) {
      _getTotalStats();
    }
  }

  @override
  void dispose() {
    _transactionsStateProvider.removeListener(_transactionStateListener);
    _walletStateProvider.removeListener(_walletStateListener);
    _state = ViewState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ViewState.init) {
      _totalStatsProvider = Provider.of<TransactionTotalStatsProvider>(context);

      _transactionsStateProvider = Provider.of<TransactionStateProvider>(context);
      _transactionsStateProvider.addListener(_transactionStateListener);

      _walletStateProvider = Provider.of<WalletStateProvider>(context);
      _walletStateProvider.addListener(_walletStateListener);
      _getTotalStats();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case ViewState.done:
      case ViewState.error:
      case ViewState.empty:
        final isNeutral = _state == ViewState.error ? false : _totalStatsProvider.item!.totalTransaction.abs() <= 0.01;
        return GestureDetector(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: ((_) => const WalletStatsPage()))),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              color: AppColors().primaryColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  offset: Offset(2.0, 2.0),
                  blurRadius: 5.0,
                  spreadRadius: 1.0
                )
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Text(
                        "Total Balance",
                        style: TextStyle(
                          fontSize: 14, 
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )
                      ),
                    ),
                    ToggleButtons(
                      borderWidth: 0,
                      selectedColor: Colors.transparent,
                      borderColor: Colors.transparent,
                      fillColor: Colors.transparent,
                      selectedBorderColor: Colors.transparent,
                      disabledBorderColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      children: [
                        Text(
                          "Month", 
                          style: TextStyle(
                            color: isSelected[0] ? Colors.white : Colors.black54,
                            fontSize: 12,
                            fontWeight: isSelected[0] ? FontWeight.bold : FontWeight.normal
                          )
                        ),
                        Text(
                          "Day", 
                          style: TextStyle(
                            color: isSelected[1] ? Colors.white : Colors.black54,
                            fontWeight: isSelected[1] ? FontWeight.bold : FontWeight.normal,
                            fontSize: 12, 
                          )
                        ),
                      ],
                      isSelected: isSelected,
                      onPressed: (int newIndex) {
                        setState(() {
                          var falseIndex = newIndex == 0 ? 1 : 0;
                          if (!isSelected[newIndex]) {
                            isSelected[newIndex] = true;
                            isSelected[falseIndex] = false;
                            _getTotalStats();
                          }
                        });
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        (_totalStatsProvider.item!.currency.isNotEmpty ? _totalStatsProvider.item!.currency : "USD").getCurrencyFromString() 
                          + " " + _totalStatsProvider.item!.totalTransaction.abs().numToString(),
                        maxLines: 1,
                        minFontSize: 18,
                        style: TextStyle(
                          color: isNeutral
                          ? Colors.grey
                          : (_totalStatsProvider.item!.totalTransaction < 0 ? AppColors().greenColor : AppColors().redColor),
                          fontSize: 22,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(6),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "Click to see detailed statistics",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      default:
        return const LoadingView("Loading");
    }
  }
}