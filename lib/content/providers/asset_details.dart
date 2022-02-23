import 'package:asset_flutter/common/models/state.dart';
import 'package:flutter/material.dart';

class AssetDetailsStateProvider with ChangeNotifier {
  EditState state = EditState.init;

  void setState(EditState state) {
    this.state = state;
    notifyListeners();
  }
}
