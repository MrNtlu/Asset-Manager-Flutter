import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MarketPrices {
  final String name;
  final String symbol;
  final String currency;
  final String market;
  final num price;

  MarketPrices(this.name, this.symbol, this.currency, this.market, this.price);
}

class PricesProvider with ChangeNotifier {
  final List<MarketPrices> _items = [];

  List<MarketPrices> get items => _items;

  Future<BaseListResponse<MarketPrices>> getMarketPrices({
    required String type,
    required String market,
  }) async {
    _items.clear();
    
    try {
      if (market.contains("&")) {
        market = market.replaceAll("&", "%26");
      }
      final response = await http.get(
        Uri.parse(
          APIRoutes().investingRoutes.prices + "?type=$type&market=$market"
        )
      );

      var baseListResponse = response.getBaseListResponse<MarketPrices>();
      _items.addAll(baseListResponse.data);
      notifyListeners();

      return baseListResponse;
    } catch(error) {
      return BaseListResponse(error: error.toString());
    }
  }

  List<MarketPrices> filterList(String search) {
    return _items.where((
      (element) => element.name.toLowerCase().contains(search) || element.name.toLowerCase().startsWith(search) ||
      element.symbol.toLowerCase().contains(search) || element.symbol.toLowerCase().startsWith(search)
    )).toList();
  }
}
