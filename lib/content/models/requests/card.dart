import 'package:asset_flutter/common/models/json_convert.dart';

class CreditCardCreate implements JSONConverter {
  String name;
  String lastDigits;
  String cardHolder;
  String color;
  String cardType;

  CreditCardCreate(this.name, this.lastDigits, this.cardHolder, this.color, this.cardType);

  @override
  Map<String, Object> convertToJson() => {
    "name": name,
    "last_digit": lastDigits,
    "card_holder": cardHolder,
    "color": color,
    "type": cardType,
  };
}

class CreditCardUpdate implements JSONConverter {
  final String id;
  String? name;
  String? lastDigits;
  String? cardHolder;
  String? color;
  String? cardType;

  CreditCardUpdate(this.id,{this.name, this.lastDigits, this.cardHolder, this.color, this.cardType});

  @override
  Map<String, Object> convertToJson() => {
    if(name != null)
    "name": name!,
    if(lastDigits != null)
    "last_digit": lastDigits!,
    if(cardHolder != null)
    "card_holder": cardHolder!,
    if(color != null)
    "color": color!,
    if(cardType != null)
    "type": cardType!,
  };
}
