import 'package:flutter/material.dart';

class MarketSelectionStateProvider with ChangeNotifier {
  String? type;
  String? market;

  void newMarketSelection(String type, String market) {
    this.type = type;
    this.market = market;
    notifyListeners();
  }
}
