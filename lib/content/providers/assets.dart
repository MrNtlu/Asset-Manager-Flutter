import 'package:asset_flutter/content/models/responses/asset.dart';
import 'package:flutter/material.dart';

class AssetLogs with ChangeNotifier {
  final List<AssetLog> _items = [];

  List<AssetLog> get items {
    return [...items];
  }

  void addAssetLog(AssetLog value) {
    _items.add(value);
    notifyListeners();
  }
}
