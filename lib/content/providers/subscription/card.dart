import 'package:asset_flutter/common/models/response.dart';
import 'package:flutter/material.dart';

class CreditCard with ChangeNotifier {
  final String id;
  late String name;
  late String lastDigits;

  CreditCard(this.id, this.name, this.lastDigits);

  Future<BaseAPIResponse> updateCard() async {
    try {
      //TODO: Implement
      return BaseAPIResponse("");
    } catch (error) {
      return BaseAPIResponse(error.toString());
    }
  }
}
