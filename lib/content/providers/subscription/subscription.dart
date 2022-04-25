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
  late DateTime nextBillDate;
  late BillCycle billCycle;
  late num price;
  late String currency;
  late String? _image;
  late String _color;
  late String? cardID;

  int get color => int.parse(_color);

  String? get image {
    if (_image != null) {
      return _subscriptionImage(_image!);
    }
    return null;
  }

  String? get rawImage => _image;

  Subscription(this.id, this.name, this.description, this.billDate, this.nextBillDate,
      this.billCycle, this.price, this.currency, this._image, this._color, this.cardID);

  String _subscriptionImage(String company) {
    return "https://logo.clearbit.com/$company";
  }

  Future<BaseItemResponse<Subscription>> updateSubscription(SubscriptionUpdate update) async {
    try {
      final response = await http.put(
        Uri.parse(APIRoutes().subscriptionRoutes.updateSubscription),
        body: json.encode(update.convertToJson()),
        headers: UserToken().getBearerToken(),
      );

      var baseItemResponse = response.getBaseItemResponse<Subscription>();
      var data = baseItemResponse.data;

      if (baseItemResponse.error == null && data != null) {
        name = data.name;
        description = data.description;
        billDate = data.billDate;
        nextBillDate = data.nextBillDate;
        billCycle = data.billCycle;
        price = data.price;
        currency = data.currency;
        _image = data.image;
        _color = (data.color).toString();
        cardID = data.cardID;

        notifyListeners();
      }

      return baseItemResponse;
    } catch (error) {
      return BaseItemResponse(message: error.toString(), error: error.toString());
    }
  }
}
