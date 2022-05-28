import 'package:asset_flutter/common/models/json_convert.dart';

class BankAccountCreate implements JSONConverter {
  String name;
  String iban;
  String accountHolder;
  String currency;

  BankAccountCreate(this.name, this.iban, this.accountHolder, this.currency);

  @override
  Map<String, Object> convertToJson() => {
    "name": name,
    "iban": iban,
    "account_holder": accountHolder,
    "currency": currency
  };
}

class BankAccountUpdate implements JSONConverter {
  final String id;
  String? name;
  String? iban;
  String? accountHolder;
  String? currency;

  BankAccountUpdate(this.id, {this.name, this.iban, this.accountHolder, this.currency});

  @override
  Map<String, Object> convertToJson() => {
    "id": id,
    if(name != null)
    "name": name!,
    if(iban != null)
    "iban": iban!,
    if(accountHolder != null)
    "account_holder": accountHolder!,
    if(currency != null)
    "currency": currency!
  };
}