import 'dart:math';

import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/models/requests/subscription.dart';
import 'package:asset_flutter/content/models/responses/subscription.dart';
import 'package:asset_flutter/content/providers/subscription.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Subscriptions with ChangeNotifier {
  final List<Subscription> _items = [
    Subscription('1', "Netflix 4K Family for Friends and Me", "Netflix Family Plan", DateTime.now(), BillCycle(month: 3), 40.5, 'TL', "netflix.com", 0xFFE53935),
    Subscription('2', "Spotify", null, DateTime.now().subtract(const Duration(days: 5)), BillCycle(month: 1), 27.5, 'TL', "spotify.com", 0xFF4CAF50),
    Subscription('3', "Playstation Plus", "Playstation Plus and this is an example of long text, lets see hot it'll behave.", DateTime.now().subtract(const Duration(days: 15)), BillCycle(year: 1), 165.2, 'TL', "playstation.com", 0xFF1976D2),
    Subscription('4', "Jefit", null, DateTime.now().subtract(const Duration(days: 2)), BillCycle(day: 7), 10.9, 'USD', "jefit.com", 0xFF03A9F4),
    Subscription('5', "WoW", null, DateTime.now().subtract(const Duration(days: 147)), BillCycle(year: 1), 60.2, 'USD', "worldofwarcraft.com", 0xFF4CAF50),
  ];

  List<Subscription> get items {
    return [..._items];
  }

  Subscription findById(String id) {
    return _items.firstWhere((element) => element.id == id);
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
          subsCreate.currency, subsCreate.image, subsCreate.color)
        );
        notifyListeners();
      }

      return response.getBaseResponse();
    }catch(error){
      return BaseAPIResponse(error.toString());
    }
  }

  void deleteSubscription(String id) {
    final deleteItem = findById(id);
    _items.remove(deleteItem);
    notifyListeners();
  }
}