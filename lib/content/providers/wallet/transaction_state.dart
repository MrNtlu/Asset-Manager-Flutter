import 'package:flutter/material.dart';

class TransactionStateProvider with ChangeNotifier {
  bool shouldRefresh = false;

  void setRefresh(bool shouldRefresh) {
    this.shouldRefresh = shouldRefresh;
    notifyListeners();
    this.shouldRefresh = false;
  }
}