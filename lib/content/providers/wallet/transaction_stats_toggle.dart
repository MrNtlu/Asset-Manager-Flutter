import 'package:flutter/material.dart';

class TransactionStatsToggleProvider with ChangeNotifier {
  String? selectedInterval;

  void onIntervalChanged(String interval) {
    selectedInterval = interval;
    notifyListeners();
    selectedInterval = null;
  }
}