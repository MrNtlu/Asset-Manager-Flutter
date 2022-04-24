import 'dart:math';
import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/models/requests/subscription.dart';
import 'package:asset_flutter/content/models/responses/subscription.dart';
import 'package:asset_flutter/content/providers/subscription/subscription.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SubscriptionsProvider with ChangeNotifier {
  final List<Subscription> _items = [];
  final List<SubscriptionStats> _stats = [];

  List<SubscriptionStats> get stats => _stats;

  List<Subscription> get items => _items;

  Subscription findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<SubscriptionResponse> getSubscriptions({
    required String sort, //name currency price
    required int type
  }) async {
    _items.clear();
    _stats.clear();
    try {
      final response = await http.get(
        Uri.parse(
          APIRoutes().subscriptionRoutes.subscriptionsByUserID + "?sort=$sort&type=$type"
        ),
        headers: UserToken().getBearerToken()
      );

      var subsStatsResponse = response.getSubscriptionStatsResponse();
      _items.addAll(subsStatsResponse.data);
      _stats.addAll(subsStatsResponse.stats);

      notifyListeners();

      return subsStatsResponse;
    } catch (error) {
      return SubscriptionResponse(error: error.toString());
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
          subsCreate.currency, subsCreate.image, subsCreate.color.toString(), subsCreate.cardID)
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