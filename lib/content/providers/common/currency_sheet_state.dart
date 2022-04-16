import 'package:flutter/material.dart';

class CurrencySheetSelectionStateProvider with ChangeNotifier {
  String? symbol;

  void currencySelectionChanged(String symbolSelection) {
    if (symbol != symbolSelection) {
      symbol = symbolSelection;
      notifyListeners();
    }
  }
}