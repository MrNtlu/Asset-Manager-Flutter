import 'dart:io';

import 'package:asset_flutter/common/widgets/sort_list.dart';
import 'package:asset_flutter/content/providers/wallet/transaction_sheet_state.dart';
import 'package:asset_flutter/content/widgets/wallet/transaction_filter_sheet_category_list.dart';
import 'package:asset_flutter/content/widgets/wallet/transaction_sheet_banks.dart';
import 'package:asset_flutter/content/widgets/wallet/transaction_sheet_cards.dart';
import 'package:asset_flutter/content/widgets/wallet/transaction_sheet_datepicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionFilterSheet extends StatelessWidget {
  const TransactionFilterSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<TransactionSheetSelectionStateProvider>(context, listen: false);

    final _dateRangePicker = TransactionSheetDateRangePicker();
    _dateRangePicker.dateTimeRange = _provider.selectedTimeRange;
    
    final _creditCardPicker = TransactionSheetCreditCards();
    _creditCardPicker.selectedCard = _provider.selectedCard;
    
    final _bankAccPicker = TransactionSheetBankAccounts();
    _bankAccPicker.selectedBankAcc = _provider.selectedBankAcc;

    final _categoryList = TransactionFilterSheetCategoryList();
    _categoryList.selectedCategory = _provider.selectedCategory;

    final sortListView = SortList(
      const ["Date", "Price"], 
      fontSize: 16, 
      selectedIndex: _provider.sort != null
      ? const ["Date", "Price"].indexOf(_provider.sort!)
      : 0,
    );
    final sortTypeListView = SortList(
      const ["Descending", "Ascending"], 
      fontSize: 16, 
      selectedIndex: _provider.sort != null
      ? const ["Descending", "Ascending"].indexOf(_provider.sortType!)
      : 0,
    );

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 74),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _filterTitle("Category"),
                    _categoryList,
                    const Divider(),
                    _filterTitle("Date Range"),
                    _dateRangePicker,
                    const Divider(),
                    _filterTitle("Bank Account"),
                    _bankAccPicker,
                    const Divider(),
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
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Platform.isIOS || Platform.isMacOS
                  ? CupertinoButton(
                    color: CupertinoColors.systemGrey,
                    child: const Text('Reset', style: TextStyle(color: Colors.white)), 
                    onPressed: () { 
                      Provider.of<TransactionSheetSelectionStateProvider>(context, listen: false).resetSelection();
                      Navigator.pop(context);
                    }
                  )
                  : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: CupertinoColors.systemGrey
                        ),
                        onPressed: () { 
                          Provider.of<TransactionSheetSelectionStateProvider>(context, listen: false).resetSelection();
                          Navigator.pop(context); 
                        },
                        child: const Text('Reset', style: TextStyle(color: Colors.white))
                      ),
                    ),
                  ),
                  Platform.isIOS || Platform.isMacOS
                  ? CupertinoButton.filled(
                    child: const Text('Apply', style: TextStyle(color: Colors.white)), 
                    onPressed: () {
                      Provider.of<TransactionSheetSelectionStateProvider>(context, listen: false).selectionChanged(
                        _dateRangePicker.dateTimeRange, _creditCardPicker.selectedCard, _bankAccPicker.selectedBankAcc, 
                        _categoryList.selectedCategory, sortListView.getSelectedItem(), sortTypeListView.getSelectedItem()
                      );
                      Navigator.pop(context);
                    }
                  )
                  : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ElevatedButton(
                        onPressed: () {
                          Provider.of<TransactionSheetSelectionStateProvider>(context, listen: false).selectionChanged(
                            _dateRangePicker.dateTimeRange, _creditCardPicker.selectedCard, _bankAccPicker.selectedBankAcc, 
                            _categoryList.selectedCategory, sortListView.getSelectedItem(), sortTypeListView.getSelectedItem()
                          );
                          Navigator.pop(context);
                        }, 
                        child: const Text('Apply', style: TextStyle(color: Colors.white))
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }

  Widget _filterTitle(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 6, top: 12),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      )
    ),
  );
}