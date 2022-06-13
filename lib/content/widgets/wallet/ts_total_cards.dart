import 'package:asset_flutter/content/providers/wallet/transaction_stats.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionStatsTotalCards extends StatelessWidget {
  final bool isExpense;
  const TransactionStatsTotalCards(this.isExpense, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isExpense ? AppColors().redColor : AppColors().greenColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isExpense ? "Expense" : "Income",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Consumer<TransactionStatsProvider>(builder: ((context, value, _) {
                final data = value.item!;
                final _totalData = isExpense ? data.totalExpense : data.totalIncome;

                return AutoSizeText(
                  data.categoryStats.currency.getCurrencyFromString() + _totalData.abs().numToString(),
                  maxLines: 1,
                  minFontSize: 16,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                  ),
                );
              }))
            ),
          ],
        ),
      ),
    );
  }
}