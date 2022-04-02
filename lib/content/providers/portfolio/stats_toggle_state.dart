import 'package:flutter/material.dart';

class StatsToggleSelectionStateProvider with ChangeNotifier {
  String? interval;

  void newIntervalSelected(String interval) {
    this.interval = interval;
    notifyListeners();
  }
}
