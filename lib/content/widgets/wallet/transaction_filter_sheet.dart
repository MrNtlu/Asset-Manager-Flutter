import 'dart:io';

import 'package:asset_flutter/common/widgets/sort_list.dart';
import 'package:asset_flutter/content/widgets/wallet/transaction_filter_sheet_category_list.dart';
import 'package:asset_flutter/content/widgets/wallet/transaction_sheet_banks.dart';
import 'package:asset_flutter/content/widgets/wallet/transaction_sheet_cards.dart';
import 'package:asset_flutter/content/widgets/wallet/transaction_sheet_datepicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionFilterSheet extends StatelessWidget {
  const TransactionFilterSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _dateRangePicker = TransactionSheetDateRangePicker();
    final _creditCardPicker = TransactionSheetCreditCards();
    final _bankAccPicker = TransactionSheetBankAccounts();
    final _categoryList = TransactionFilterSheetCategoryList();
    final sortListView = SortList(const ["Date", "Price"]);
    final sortTypeListView = SortList(const ["Ascending", "Descending"]);

    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _filterTitle("Category"),
              _categoryList,
              _filterTitle("Date Range"),
              _dateRangePicker,
              _filterTitle("Bank Account"),
              _bankAccPicker,
              _filterTitle("Credit Card"),
              _creditCardPicker,
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: sortListView
                  ),
                  Expanded(
                    child: sortTypeListView
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Platform.isIOS || Platform.isMacOS
                    ? CupertinoButton(
                      child: const Text('Cancel'), 
                      onPressed: () => Navigator.pop(context)
                    )
                    : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextButton(
                          onPressed: () => Navigator.pop(context), 
                          child: const Text('Cancel')
                        ),
                      ),
                    ),
                    Platform.isIOS || Platform.isMacOS
                    ? CupertinoButton.filled(
                      child: const Text('Apply'), 
                      onPressed: () {
                        //TODO: On pressed
                        Navigator.pop(context);
                      }
                    )
                    : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            //TODO: On pressed
                            Navigator.pop(context);
                          }, 
                          child: const Text('Apply')
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  Widget _filterTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 6, top: 12),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black
      )
    ),
  );
}