import 'dart:convert';
import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/models/requests/asset.dart';
import 'package:asset_flutter/content/providers/asset.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AssetsProvider with ChangeNotifier {
  final List<Asset> _items = [];

  List<Asset> get items => _items;

  Asset findByAsset(String toAsset, String fromAsset) {
    return _items.firstWhere((element) => element.toAsset == toAsset && element.fromAsset == fromAsset);
  }

  Future<BaseListResponse<Asset>> getAssets({
    String sort = "name", //name value amount profit
    int type = 1
  }) async {
    _items.clear();
    try {
      final response = await http.get(
        Uri.parse(APIRoutes().assetRoutes.assetsByUserID + "?sort=$sort&type=$type"),
        headers: UserToken().getBearerToken(),
      );
      
      var baseListResponse = response.getBaseListResponse<Asset>();
      _items.addAll(baseListResponse.data);
      notifyListeners();

      return baseListResponse;
    } catch (error) {
      return BaseListResponse(error: error.toString());
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
}
