import 'dart:ffi';

import 'package:asset_flutter/content/providers/assets.dart';

class AssetCreate {
  final String toAsset;
  final String fromAsset;
  final double? boughtPrice;
  final double? soldPrice;
  final double amount;
  final String assetType; //crypto stock exchange
  final String type; //sell buy

  const AssetCreate(
      this.toAsset, this.fromAsset, this.type, this.amount, this.assetType,
      {this.boughtPrice, this.soldPrice});
}

class AssetSort {
  final String sort; //name value amount profit
  final int sortType; //1 -1

  const AssetSort(this.sort, this.sortType);
}

class AssetDetailsFilter {
  final String toAsset;
  final String fromAsset;

  const AssetDetailsFilter(this.toAsset, this.fromAsset);
}

class AssetLogFilter {
  final String toAsset;
  final String fromAsset;
  final String? type; //sell buy
  final String sort; //newest oldest amount
  final int page;

  const AssetLogFilter(this.toAsset, this.fromAsset, this.sort, this.page,
      {this.type});
}

class AssetUpdate {
  final String id;
  final double? boughtPrice;
  final double? soldPrice;
  final double amount;

  const AssetUpdate(this.id, this.amount, {this.boughtPrice, this.soldPrice});
}

class AssetLogsDelete {
  final String toAsset;
  final String fromAsset;

  const AssetLogsDelete(this.toAsset, this.fromAsset);
}
