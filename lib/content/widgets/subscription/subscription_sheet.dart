import 'dart:io';
import 'package:asset_flutter/common/widgets/sort_sheet.dart';
import 'package:asset_flutter/content/models/responses/subscription.dart';
import 'package:asset_flutter/content/pages/subscription/card_page.dart';
import 'package:asset_flutter/content/pages/wallet/bank_account_page.dart';
import 'package:asset_flutter/content/widgets/subscription/subscription_stats_sheet.dart';
import 'package:flutter/material.dart';

class SubscriptionSheet extends StatelessWidget {
  final List<SubscriptionStats> _stats;
  final String _sort;
  final int _sortType;
  
  const SubscriptionSheet(this._stats, this._sort, this._sortType, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  shape: Platform.isIOS || Platform.isMacOS
                  ? const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16)
                    ),
                  )
                  : null,
                  enableDrag: false,
                  isDismissible: true,
                  isScrollControlled: true,
                  builder: (_) => SortSheet(
                    const ["Name", "Currency", "Price"],
                    const ["Ascending", "Descending"],
                    selectedSort: const ["Name", "Currency", "Price"].indexOf("${_sort[0].toUpperCase()}${_sort.substring(1)}"),
                    selectedSortType: _sortType == -1 ? 0 : 1,
                  )
                );
              }, 
              icon: const Icon(Icons.filter_alt_rounded, size: 26),
              label: const Padding(
                padding: EdgeInsets.only(left: 8),
                child: SizedBox(
                  width: 175,
                  child: Text(
                    "Sort Subscriptions",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Divider(),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                shape: Platform.isIOS || Platform.isMacOS
                ? const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    topLeft: Radius.circular(16)
                  ),
                )
                : null,
                enableDrag: true,
                isDismissible: true,
                builder: (_) => SubscriptionStatsSheet(_stats)
              );
            }, 
            icon: const Icon(Icons.bar_chart_rounded, size: 28),
            label: const Padding(
              padding: EdgeInsets.only(left: 8),
              child: SizedBox(
                width: 175,
                child: Text(
                  "Subscription Stats",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ),
          const Divider(),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: ((_) {
                  return const CardPage();
                }))
              );
            }, 
            icon: const Icon(Icons.credit_card_rounded, size: 26),
            label: const Padding(
              padding: EdgeInsets.only(left: 8),
              child: SizedBox(
                width: 175,
                child: Text(
                  "Credit Cards",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ),
          const Divider(),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: ((_) {
                  return const BankAccountPage();
                }))
              );
            }, 
            icon: const Icon(Icons.account_balance_rounded, size: 26),
            label: const Padding(
              padding: EdgeInsets.only(left: 8),
              child: SizedBox(
                width: 175,
                child: Text(
                  "Bank Accounts",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ),
          const Divider(),
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            )
          )
        ],
      ),
    );
  }
}