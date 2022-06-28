import 'dart:convert';
import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/models/requests/asset.dart';
import 'package:asset_flutter/content/models/responses/asset.dart';
import 'package:asset_flutter/content/providers/asset.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AssetsProvider with ChangeNotifier {
  final List<Asset> _items = [];
  AssetStats? assetStats;

  List<Asset> get items => _items;

  Asset findByAsset(String toAsset, String fromAsset) {
    return _items.firstWhere((element) => element.toAsset == toAsset && element.fromAsset == fromAsset);
  }

  Future<AssetResponse> getAssets({
    required String sort, //name amount profit type
    required int type,
    required List<String> assetTypes,
  }) async {
    _items.clear();

    String sortFilter = "?sort=$sort&type=$type";

    if (assetTypes.isNotEmpty) {
      if (assetTypes.length > 1) {
        sortFilter += "&asset_type=${assetTypes.map((e) => e.toLowerCase()).join(",")}";
      } else if (assetTypes.length == 1) {
        sortFilter += "&asset_type=${assetTypes[0].toLowerCase()}";
      }
    }

    try {
      final response = await http.get(
        Uri.parse(APIRoutes().assetRoutes.assetsByUserID + sortFilter),
        headers: UserToken().getBearerToken(),
      );
      
      var assetResponse = response.getStatsResponse();
      _items.addAll(assetResponse.data);
      assetStats = assetResponse.stats;

      notifyListeners();

      return assetResponse;
    } catch (error) {
      return AssetResponse(error: error.toString());
    }
  }

  Future<BaseAPIResponse> createAsset(AssetCreate assetCreate) async {
    try {
      final response = await http.post(
        Uri.parse(APIRoutes().assetRoutes.createAsset),
        body: json.encode(assetCreate.convertToJson()),
        headers: UserToken().getBearerToken()
      );

      return response.getBaseResponse();
    } catch (error) {
      return BaseAPIResponse(error.toString());
    }
  }

  Future<BaseAPIResponse> deleteAllAssetLogs(String toAsset, String fromAsset, String assetMarket) async {
    try {
      final response = await http.delete(
        Uri.parse(APIRoutes().assetRoutes.deleteAssetLogsByUserID),
        body: json.encode({
          "to_asset": toAsset,
          "from_asset": fromAsset,
          "asset_market": assetMarket
        }),
        headers: UserToken().getBearerToken()
      );

      if (response.getBaseResponse().error == null) {
        final deleteItem = findByAsset(toAsset, fromAsset);
        _items.remove(deleteItem);
        notifyListeners();
      }

      return response.getBaseResponse();
    } catch (error) {
      return BaseAPIResponse(error.toString());
    }
  }
}
