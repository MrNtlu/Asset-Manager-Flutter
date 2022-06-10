import 'dart:io';
import 'package:asset_flutter/content/models/responses/subscription.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';

class SubscriptionStatsSheet extends StatelessWidget {
  final List<SubscriptionStats> _statList;

  const SubscriptionStatsSheet(this._statList, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(bottom: 16),
        decoration: Platform.isIOS || Platform.isMacOS
        ? const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16)
          ),
        )
        : null,
        child: DataTable(
          columns: const [
            DataColumn(
              numeric: false,
              label: FittedBox(
                child: null,
              ),
            ),
            DataColumn(
              numeric: true,
              label: FittedBox(
                child: Text(
                  "Monthly",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
              ),
            ),
            DataColumn(
              numeric: true,
              label: FittedBox(
                child: Text(
                  "Total Paid",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
              ),
            ),
          ],
          rows: [
            if(_statList.isEmpty)
            const DataRow(
              cells: [
                DataCell(
                  Text("No Data", style: TextStyle(fontWeight: FontWeight.bold))
                ),
                DataCell(
                  Text("")
                ),
                DataCell(
                  Text("")
                ),
              ]
            ),            
            for (var _statsData in _statList) 
            DataRow(
              cells: [
                DataCell(
                  Text(_statsData.currency, style: const TextStyle(fontWeight: FontWeight.bold))
                ),
                DataCell(
                  Text(_statsData.currency.getCurrencyFromString() + _statsData.monthlyPayment.numToString())
                ),
                DataCell(
                  Text(_statsData.currency.getCurrencyFromString() + _statsData.totalPayment.numToString())
                ),
              ]
            )
          ],
        ),
      )
    );
  }
}