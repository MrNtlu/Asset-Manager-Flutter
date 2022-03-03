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

  Future<BaseAPIResponse> addAssetLog(AssetCreate assetCreate) async {
    try {
      final response = await http.post(
        Uri.parse(APIRoutes().assetRoutes.createAsset),
        body: json.encode(assetCreate.convertToJson()),
        headers: UserToken().getBearerToken(),
      );
      
      return response.getBaseResponse();
    } catch (error) {
      return BaseAPIResponse(error.toString());
    }
  }

  Future<BaseAPIResponse> deleteAssetLog(String id) async {
    try {
      final response = await http.delete(
        Uri.parse(APIRoutes().assetRoutes.deleteAssetLogByLogID),
        body: json.encode({
          "id": id
        }),
        headers: UserToken().getBearerToken()
      );

      if (response.getBaseResponse().error == null) {
        _items.removeWhere((element) => element.id == id);
        notifyListeners();
      }

      return response.getBaseResponse();
    } catch (error) {
      return BaseAPIResponse(error.toString());
    }
  }

  Future<BaseAPIResponse> editAssetLog(AssetLog assetLog, bool isAmountChanged) async {
    try {
      final response = await http.put(
        Uri.parse(APIRoutes().assetRoutes.updateAssetLogByAssetID),
        body: json.encode(
          AssetUpdate(
            assetLog.id, 
            amount: isAmountChanged ? assetLog.amount.toDouble() : null,
            price: assetLog.price.toDouble(),
            type: assetLog.type
          ).convertToJson()
        ),
        headers: UserToken().getBearerToken()
      );

      if (response.getBaseResponse().error == null) {
        _items[_items.indexWhere((element) => element.id == assetLog.id)] = assetLog;
        notifyListeners();
      }

      return response.getBaseResponse();
    } catch (error) {
      return BaseAPIResponse(error.toString());
    }
  }
}
