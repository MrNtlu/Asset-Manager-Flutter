import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/models/responses/investings.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CurrenciesProvider with ChangeNotifier {
  final List<Investings> _items = [];

  List<Investings> get items => _items;

  Future<BaseListResponse<Investings>> getMarketPrices() async {
    _items.clear();
    
    try {
      final response = await http.get(
        Uri.parse(
          APIRoutes().investingRoutes.investings + "?type=exchange&market=Forex"
        )
      );

      var baseListResponse = response.getBaseListResponse<Investings>();
      _items.addAll(baseListResponse.data);
      notifyListeners();

      return baseListResponse;
    } catch(error) {
      return BaseListResponse(error: error.toString());
    }
  }
}
