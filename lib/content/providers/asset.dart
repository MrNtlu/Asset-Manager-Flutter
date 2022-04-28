import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Asset {
  num currentValue;
  final String name;
  final String toAsset;
  final String fromAsset;
  final String type;
  final String market;
  num pl;
  num plPercentage;
  num amount;


  Asset(this.currentValue, this.name, this.toAsset, this.fromAsset, this.type, this.market, this.pl, this.plPercentage, this.amount);
}

class AssetProvider with ChangeNotifier {
  Asset? asset;
  
  Future<BaseItemResponse<Asset>> getAssetStats({
    required String toAsset,
    required String fromAsset,
    required String assetMarket,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          APIRoutes().assetRoutes.assetStatsByAssetAndUserID + "?to_asset=$toAsset&from_asset=$fromAsset&asset_market=$assetMarket"
        ),
        headers: UserToken().getBearerToken()
      );

      var baseItemResponse = response.getBaseItemResponse<Asset>();
      var data = baseItemResponse.data;
      
      if (data != null) {
        asset = data;

        notifyListeners();
      }

      return baseItemResponse;
    } catch (error) {
      return BaseItemResponse(message: error.toString());
    }
  }
}