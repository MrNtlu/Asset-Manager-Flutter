
import 'package:flutter/material.dart';

class PortfolioFilterProvider with ChangeNotifier {
  final List<String> filterList = [];

  void filterSelectionAdded(String filter) {
    filterList.add(filter);
    notifyListeners();
  }

  void filterSelectionRemoved(String filter) {
    filterList.remove(filter);
    notifyListeners();
  }
}