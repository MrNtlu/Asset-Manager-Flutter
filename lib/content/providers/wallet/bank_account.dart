import 'dart:convert';

import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/models/requests/bank_account.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BankAccount with ChangeNotifier {
  final String id;
  late String name;
  late String iban;
  late String accountHolder;
  late String currency;

  BankAccount(this.id, this.name, this.iban, this.accountHolder, this.currency);

  Future<BaseItemResponse<BankAccount>> updateBankAccount(BankAccountUpdate bankAccUpdate) async {
    try {
      final response = await http.put(
        Uri.parse(APIRoutes().cardRoutes.updateCard),
        body: json.encode(bankAccUpdate.convertToJson()),
        headers: UserToken().getBearerToken(),
      );

      var baseItemResponse = response.getBaseItemResponse<BankAccount>();
      var data = baseItemResponse.data;

      if (baseItemResponse.error == null && data != null) {
        name = data.name;
        iban = data.iban;
        accountHolder = data.accountHolder;
        currency = data.currency;

        notifyListeners();
      }

      return baseItemResponse;
    } catch (error) {
      return BaseItemResponse(message: error.toString(), error: error.toString());
    }
  }
}
