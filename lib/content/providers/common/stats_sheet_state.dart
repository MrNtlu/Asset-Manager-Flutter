import 'package:flutter/material.dart';

class StatsSheetSelectionStateProvider with ChangeNotifier {
  String? sort;
  String? sortType;

  void sortSelectionChanged(String sortSelection, String sortTypeSelection) {
    var isChanged = false;
    if (sort != sortSelection) {
      sort = sortSelection;
      isChanged = true;
    }
    if (sortType != sortTypeSelection) {
      sortType = sortTypeSelection;
      isChanged = true;
    }

    if (isChanged) {
      notifyListeners();
      sort = null;
      sortType = null;
    }
  }
}
