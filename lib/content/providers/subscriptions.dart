import 'dart:math';

import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/models/requests/subscription.dart';
import 'package:asset_flutter/content/providers/subscription.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SubscriptionsProvider with ChangeNotifier {
  final List<Subscription> _items = [];

  List<Subscription> get items {
    return [..._items];
  }

  Subscription findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<BaseListResponse<Subscription>> getSubscriptions({
    String sort = "name", //name currency price
    int type = 1
  }) async {
    _items.clear();
    try {
      final response = await http.get(
        Uri.parse(
          APIRoutes().subscriptionRoutes.subscriptionsByUserID + "?sort=$sort&type=$type"
        ),
        headers: UserToken().getBearerToken()
      );

      var baseListResponse = response.getBaseListResponse<Subscription>();
      _items.addAll(baseListResponse.data);
      notifyListeners();

      return baseListResponse;
    } catch (error) {
      return BaseListResponse(error: error.toString());
    }
  }

  Future<BaseAPIResponse> addSubscription(SubscriptionCreate subsCreate) async {
    try {
      final response = await http.post(
        Uri.parse(APIRoutes().subscriptionRoutes.createSubscription),
        body: json.encode(subsCreate.convertToJson()),
        headers: UserToken().getBearerToken(),
      );

      if (response.getBaseResponse().error == null) {  
        _items.add(Subscription(
          Random().nextInt(9999).toString(), subsCreate.name, subsCreate.description, 
          DateTime.now(), subsCreate.billCycle, subsCreate.price, 
          subsCreate.currency, subsCreate.image, subsCreate.color.toString())
        );
        notifyListeners();
      }

      return response.getBaseResponse();
    }catch(error){
      return BaseAPIResponse(error.toString());
    }
  }

  Future<BaseAPIResponse> deleteSubscription(String id) async {
    try {
      final response = await http.delete(
        Uri.parse(APIRoutes().subscriptionRoutes.deleteSubscriptionBySubscriptionID),
        body: json.encode({
          "id": id
        }),
        headers: UserToken().getBearerToken()
      );

      if (response.getBaseResponse().error == null) {
        final deleteItem = findById(id);
        _items.remove(deleteItem);
        notifyListeners();   
      }

      return response.getBaseResponse();
    } catch (error) {
      return BaseAPIResponse(error.toString());
    }
  }
}