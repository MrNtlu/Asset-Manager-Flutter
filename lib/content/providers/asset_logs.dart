import 'dart:convert';

import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/models/requests/asset.dart';
import 'package:asset_flutter/content/models/responses/asset.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AssetLogProvider with ChangeNotifier {
  final List<AssetLog> _items = [];

  List<AssetLog> get items => _items;

  Future<BasePaginationResponse<AssetLog>> getAssetLogs({
    required String toAsset,
    required String fromAsset,
    int page = 1,
    String sort = "newest" // newest oldest amount
  }) async {
    if (page == 1) {
      _items.clear();
    }

    try {
      final response = await http.get(
        Uri.parse(
          APIRoutes().assetRoutes.assetLogsByUserID 
          + "?to_asset=$toAsset&from_asset=$fromAsset&sort=$sort&page=$page"
        ),
        headers: UserToken().getBearerToken()  
      );

      var basePaginationResponse = response.getBasePaginationResponse<AssetLog>();
      _items.addAll(basePaginationResponse.data);
      notifyListeners();

      return basePaginationResponse;
    } catch(error) {
      return BasePaginationResponse(error: error.toString(), canNextPage: false);
    }
  }

  Future addAssetLog(AssetCreate assetCreate) async {
    try {
      final response = await http.post(
        Uri.parse(APIRoutes().assetRoutes.createAsset),
        body: json.encode(assetCreate.convertToJson()),
        headers: UserToken().getBearerToken(),
      );
      print(response.body);

    } catch (error) {
      //TODO: implement
      print("Error " + error.toString());
    }
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
