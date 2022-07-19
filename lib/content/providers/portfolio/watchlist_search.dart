import 'package:flutter/material.dart';

class WatchlistSearchProvider with ChangeNotifier {
  String search = "";

  void submitSearch(String _search) {
    search = _search;
    notifyListeners();
  }
}
