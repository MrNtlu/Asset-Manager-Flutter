import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/models/responses/subscription.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubscriptionStatsProvider with ChangeNotifier {
  final List<SubscriptionStats> _items = [];

  List<SubscriptionStats> get items => _items;

  Future<BaseListResponse<SubscriptionStats>> getSubscriptionStats() async {
    _items.clear();
    try {
      final response = await http.get(
        Uri.parse(APIRoutes().subscriptionRoutes.subscriptionStatsByUserID),
        headers: UserToken().getBearerToken()
      );

      var baseListResponse = response.getBaseListResponse<SubscriptionStats>();
      _items.addAll(baseListResponse.data);
      notifyListeners();
      
      return baseListResponse;
    } catch (error) {
      return BaseListResponse(error: error.toString());
    }
  }
}
