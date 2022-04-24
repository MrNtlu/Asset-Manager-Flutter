import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/providers/subscription/subscription.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CardSubscriptionsProvider with ChangeNotifier {
  final List<Subscription> _items = [];

  List<Subscription> get items => _items;

  Subscription findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }
  
  Future<BaseListResponse<Subscription>> getSubscriptionsByCardID({
    required String cardID,
  }) async {
    _items.clear();
    try {
      final response = await http.get(
        Uri.parse(
          APIRoutes().subscriptionRoutes.subscriptionByCardID + "?id=$cardID"
        ),
        headers: UserToken().getBearerToken()
      );

      var subsResponse = response.getBaseListResponse<Subscription>();
      _items.addAll(subsResponse.data);

      notifyListeners();

      return subsResponse;
    } catch (error) {
      return BaseListResponse(error: error.toString());
    }
  }
}