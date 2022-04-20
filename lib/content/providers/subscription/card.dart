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

  CreditCard(this.id, this.name, this.lastDigits, this.cardHolder, this.color, this.cardType);

  Future<BaseAPIResponse> updateCard(CreditCardUpdate cardUpdate) async {
    try {
      final response = await http.put(
        Uri.parse(APIRoutes().cardRoutes.updateCard),
        body: json.encode(cardUpdate.convertToJson()),
        headers: UserToken().getBearerToken(),
      );

      if (response.getBaseResponse().error == null) {
        name = cardUpdate.name ?? name;
        lastDigits = cardUpdate.lastDigits ?? lastDigits;
        cardHolder = cardUpdate.cardHolder ?? cardHolder;
        color = cardUpdate.color ?? color;
        cardType = cardUpdate.cardType ?? cardType;

        notifyListeners();
      }

      return response.getBaseResponse();
    } catch (error) {
      return BaseAPIResponse(error.toString());
    }
  }
}
