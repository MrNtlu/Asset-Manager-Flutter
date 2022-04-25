import 'dart:convert';
import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/models/requests/card.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreditCard with ChangeNotifier {
  final String id;
  late String name;
  late String lastDigits;
  late String cardHolder;
  late String color;
  late String cardType;
  late String currency;

  CreditCard(this.id, this.name, this.lastDigits, this.cardHolder, this.color, this.cardType, this.currency);

  Future<BaseItemResponse<CreditCard>> updateCard(CreditCardUpdate cardUpdate) async {
    try {
      final response = await http.put(
        Uri.parse(APIRoutes().cardRoutes.updateCard),
        body: json.encode(cardUpdate.convertToJson()),
        headers: UserToken().getBearerToken(),
      );

      var baseItemResponse = response.getBaseItemResponse<CreditCard>();
      var data = baseItemResponse.data;

      if (baseItemResponse.error == null && data != null) {
        name = data.name;
        lastDigits = data.lastDigits;
        cardHolder = data.cardHolder;
        color = data.color;
        cardType = data.cardType;
        currency = data.currency;

        notifyListeners();
      }

      return baseItemResponse;
    } catch (error) {
      return BaseItemResponse(message: error.toString(), error: error.toString());
    }
  }
}
