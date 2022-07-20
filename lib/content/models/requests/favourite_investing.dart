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

class FavouriteInvestingOrderUpdate {
  final List<Map<String, Object>> orders;

  const FavouriteInvestingOrderUpdate(this.orders);
}

class FavouriteInvestingOrder implements JSONConverter {
  final String id;
  final int priority;

  const FavouriteInvestingOrder(this.id, this.priority);
  
  @override
  Map<String, Object> convertToJson() => {
    "id": id,
    "priority": priority
  };
}
