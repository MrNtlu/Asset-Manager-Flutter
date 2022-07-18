import 'package:asset_flutter/common/models/json_convert.dart';

class FavouriteInvestingCreate implements JSONConverter {
  final String symbol;
  final String type;
  final String market;
  final int priority;

  const FavouriteInvestingCreate(
    this.symbol, this.type, this.market, this.priority
  );
  
  @override
  Map<String, Object> convertToJson() => {
    "symbol": symbol,
    "type": type,
    "market": market,
    "priority": priority
  };
}
