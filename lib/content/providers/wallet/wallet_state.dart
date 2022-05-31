import 'package:asset_flutter/common/models/state.dart';
import 'package:flutter/material.dart';

class WalletStateProvider with ChangeNotifier {
  ListState state = ListState.init;

  void setState(ListState state) {
    this.state = state;
    notifyListeners();
  }
}
