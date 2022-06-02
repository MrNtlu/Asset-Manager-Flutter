import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/providers/common/base_item_provider.dart';
import 'package:asset_flutter/static/routes.dart';

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

class AssetProvider extends BaseItemProvider<Asset> {

  Future<BaseItemResponse<Asset>> getAssetStats({
    required String toAsset,
    required String fromAsset,
    required String assetMarket,
  }) async 
    => getItem(url: APIRoutes().assetRoutes.assetStatsByAssetAndUserID + "?to_asset=$toAsset&from_asset=$fromAsset&asset_market=$assetMarket");
}