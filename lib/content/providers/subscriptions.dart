import 'dart:math';

import 'package:asset_flutter/content/models/requests/subscription.dart';
import 'package:asset_flutter/content/models/responses/subscription.dart';
import 'package:asset_flutter/content/providers/subscription.dart';
import 'package:flutter/material.dart';

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

  void addSubscription(SubscriptionCreate value) {
    _items.add(Subscription(
      Random().toString(), value.name, value.description, 
      DateTime.now(), value.billCycle, value.price, 
      value.currency, value.image, value.color));
    notifyListeners();
  }
}