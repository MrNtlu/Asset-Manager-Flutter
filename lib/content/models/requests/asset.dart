import 'package:asset_flutter/common/models/json_convert.dart';

class AssetCreate implements JSONConverter {
  String toAsset;
  String fromAsset;
  double? boughtPrice;
  double? soldPrice;
  double amount;
  String assetType; //crypto stock exchange
  String type; //sell buy
  String name;

  AssetCreate(
      this.toAsset, this.fromAsset, this.type, 
      this.amount, this.assetType, this.name,
      {this.boughtPrice, this.soldPrice});

  @override
  Map<String, Object> convertToJson() => {
    "to_asset": toAsset,
    "from_asset": fromAsset,
    if(boughtPrice != null)
    "bought_price": boughtPrice!,
    if(soldPrice != null)
    "sold_price": soldPrice!,
    "amount": amount,
    "asset_type": assetType,
    "type": type
  };
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

class AssetUpdate implements JSONConverter {
  final String id;
  final double? boughtPrice;
  final double? soldPrice;
  final double? amount;
  final String? type;

  const AssetUpdate(this.id, {
    this.amount, this.boughtPrice,
    this.soldPrice, this.type
  });

  @override
  Map<String, Object> convertToJson() => {
    "id": id,
    if(amount != null)
    "amount": amount!,
    if(boughtPrice != null)
    "bought_price": boughtPrice!,
    if(soldPrice != null)
    "sold_price": soldPrice!,
    if(type != null)
    "type": type!
  };
}

class AssetLogsDelete {
  final String toAsset;
  final String fromAsset;

  const AssetLogsDelete(this.toAsset, this.fromAsset);
}
