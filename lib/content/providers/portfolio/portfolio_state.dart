import 'package:asset_flutter/common/models/state.dart';
import 'package:flutter/material.dart';

class PortfolioRefreshProvider with ChangeNotifier {
  bool shouldRefresh = false;

  void setRefresh(bool shouldRefresh) {
    this.shouldRefresh = shouldRefresh;
    notifyListeners();
    this.shouldRefresh = false;
  }
}

class PortfolioStateProvider with ChangeNotifier {
  ListState? state;
  String? error;

  void setState(ListState state, {String? error}) {
    this.state = state;
    this.error = error;
    notifyListeners();
    this.state = null;
  }
}

class PortfolioWatchlistRefreshProvider with ChangeNotifier {
  bool shouldRefresh = false;

  void setRefresh(bool shouldRefresh) {
    this.shouldRefresh = shouldRefresh;
    notifyListeners();
    this.shouldRefresh = false;
  }
}