import 'dart:io';
import 'package:asset_flutter/common/widgets/currency_list.dart';
import 'package:asset_flutter/content/providers/common/currency_sheet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CurrencySheet extends StatelessWidget {
  final String selectedSymbol;
  
  const CurrencySheet({this.selectedSymbol = "USD", Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _currencySheetProvider = Provider.of<CurrencySheetSelectionStateProvider>(context, listen: false);
    var _currencyList = CurrencyList(selectedSymbol);

    return SafeArea(
      child: Container(
        height: 325,
        padding: const EdgeInsets.all(4),
        decoration: Platform.isIOS || Platform.isMacOS
        ? const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16)
          ),
        )
        : null,
        child: Column(
          children: [
            Expanded(
              child: _currencyList,
            ),
            Row(
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
                    _currencySheetProvider.currencySelectionChanged(_currencyList.selectedSymbol);
                    Navigator.pop(context);
                  }
                )
                : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        _currencySheetProvider.currencySelectionChanged(_currencyList.selectedSymbol);
                        Navigator.pop(context);
                      }, 
                      child: const Text('Apply')
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      )
    );
  }
}