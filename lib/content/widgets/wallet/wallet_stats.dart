import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/content/pages/subscription/card_page.dart';
import 'package:asset_flutter/content/pages/wallet/bank_account_page.dart';
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
        return Container(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      PopupMenuButton(
                        onSelected: (item) {
                          switch (item) {
                            case 0:
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: ((_) {
                                  return const CardPage();
                                }))
                              );
                              break;
                            case 1:
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: ((_) {
                                  return const BankAccountPage();
                                }))
                              );
                              break;
                          }
                        },
                        itemBuilder: (ctx) => [
                          PopupMenuItem(
                            value: 0,
                            child: Row(
                              children: const [
                                Icon(Icons.credit_card_rounded),
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text("Credit Cards"),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 1,
                            child: Row(
                              children: const [
                                Icon(Icons.account_balance_rounded),
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text("Bank Accounts"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: ((_) => const WalletStatsPage()))),
                        icon: const Icon(Icons.stacked_bar_chart_rounded),
                      ),
                    ],
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
                      _toggleButton("Month", 0),
                      _toggleButton("Day", 1),
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
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  "Total Balance",
                  style: TextStyle(
                    fontSize: 14, 
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
                child: Align(
                  alignment: Alignment.center,
                  child: AutoSizeText(
                    (_totalStatsProvider.item!.currency.isNotEmpty ? _totalStatsProvider.item!.currency : "USD").getCurrencyFromString() 
                      + " " + _totalStatsProvider.item!.totalTransaction.abs().numToString(),
                    maxLines: 1,
                    minFontSize: 18,
                    style: TextStyle(
                      color: isNeutral
                      ? Colors.grey
                      : (_totalStatsProvider.item!.totalTransaction < 0 ? AppColors().greenColor : AppColors().redColor),
                      fontSize: 34,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      default:
        return const LoadingView("Loading");
    }
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