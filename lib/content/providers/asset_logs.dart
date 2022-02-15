import 'package:asset_flutter/content/models/responses/asset.dart';
import 'package:flutter/material.dart';

class AssetLogProvider with ChangeNotifier {
  final List<AssetLog> _items = [
    AssetLog('1', 475.2855, "BTC", "USD", "buy", 0.01, DateTime.now(), boughtPrice: 47528.55),
    AssetLog('2', 348.062, "BTC", "USD", "buy", 0.006, DateTime.now().subtract(const Duration(days: 3)), boughtPrice: 58001.27),
    AssetLog('3', 252, "BTC", "USD", "sell", 0.000782, DateTime.now(), soldPrice: 53582.55),
    AssetLog('4', 93.084, "BTC", "USD", "buy", 0.0015, DateTime.now().subtract(const Duration(days: 33)), boughtPrice: 62056),
    AssetLog('5', 252, "BTC", "USD", "sell", 0.000782, DateTime.now(), soldPrice: 53582.55),
    AssetLog('6', 102.3, "BTC", "USD", "sell", 0.00313, DateTime.now(), soldPrice: 35528.55),
    AssetLog('7', 93.084, "BTC", "USD", "buy", 0.0015, DateTime.now().subtract(const Duration(days: 67)), boughtPrice: 62056),
    AssetLog('8', 102.3, "BTC", "USD", "sell", 0.00313, DateTime.now(), soldPrice: 35528.55),
    AssetLog('9', 93.084, "BTC", "USD", "buy", 0.0015, DateTime.now().subtract(const Duration(days: 395)), boughtPrice: 62056),
    AssetLog('10', 102.3, "BTC", "USD", "sell", 0.00313, DateTime.now().subtract(const Duration(days: 462)), soldPrice: 35528.55),
  ];

  List<AssetLog> get items {
    _items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return [..._items];
  }

  void addAssetLog(AssetLog value) {
    _items.add(value);
    notifyListeners();
  }

  void deleteAssetLog(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void editAssetLog(AssetLog assetLog) {
    _items[_items.indexWhere((element) => element.id == assetLog.id)] = assetLog;
    notifyListeners();
  }
}
