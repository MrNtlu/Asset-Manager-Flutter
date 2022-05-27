import 'package:flutter/material.dart';

class TransactionDateRangeSelectionStateProvider with ChangeNotifier {
  DateTimeRange? selectedTimeRange;

  void selectionChanged(DateTime startDate, DateTime endDate) {
    selectedTimeRange = DateTimeRange(start: startDate, end: endDate);
    notifyListeners();
  }
}
