import 'dart:convert';

import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/models/requests/subscription.dart';
import 'package:asset_flutter/content/models/responses/subscription.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Subscription with ChangeNotifier {
  final String id;
  late String name;
  late String? description;
  late DateTime billDate;
  late BillCycle billCycle;
  late double price;
  late String currency;
  late String? image;
  late int color;

  Subscription(this.id, this.name, this.description, this.billDate,
      this.billCycle, this.price, this.currency, this.image, this.color) {
    if (image != null) {
      image = _subscriptionImage(image!);
    }
  }

  String _subscriptionImage(String company) {
    return "https://logo.clearbit.com/$company";
  }

  Future<BaseAPIResponse> updateSubscription(SubscriptionUpdate update) async {
    try {
      final response = await http.put(
        Uri.parse(APIRoutes().subscriptionRoutes.updateSubscription),
        body: json.encode(update.convertToJson()),
        headers: UserToken().getBearerToken(),
      );

      if (response.getBaseResponse().error == null) {
        name = update.name ?? name;
        description = update.description ?? description;
        billDate = update.billDate ?? billDate;
        price = update.price ?? price;
        currency = update.currency ?? currency;
        image = update.image ?? image;
        color = update.color ?? color;

        notifyListeners();
      }

      return response.getBaseResponse();
    } catch (error) {
      return BaseAPIResponse(error.toString());
    }
  }
}
