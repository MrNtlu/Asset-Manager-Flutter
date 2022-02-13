import 'package:asset_flutter/common/models/json_convert.dart';
import 'package:asset_flutter/content/models/responses/subscription.dart';
import 'package:asset_flutter/utils/extensions.dart';

class SubscriptionCreate implements JSONConverter{
  String name;
  String? description;
  String? cardID;
  late DateTime billDate;
  BillCycle billCycle;
  double price;
  String currency;
  String? image;
  int color;

  SubscriptionCreate(this.name, this.billCycle, this.billDate, this.price,
      this.currency, this.image, this.color,
      {this.cardID, this.description});

  @override
  Map<String, Object> convertToJson() => {
    "name": name,
    if(description != null)
    "description": description!,
    "bill_date": billDate.dateToJSONFormat(),
    "bill_cycle": billCycle.convertToJson(),
    "price": price,
    "currency": currency,
    if(image != null)
    "image": image!,
    "color": color.toString()
  };
}

class SubscriptionUpdate implements JSONConverter {
  final String id;
  String? name;
  String? description;
  DateTime? billDate;
  BillCycle? billCycle;
  double? price;
  String? currency;
  String? cardID;
  String? image;
  int? color;

  SubscriptionUpdate(this.id,
      {this.name,
      this.description,
      this.billDate,
      this.billCycle,
      this.price,
      this.currency,
      this.cardID,
      this.image,
      this.color});

  @override
  Map<String, Object> convertToJson() => {
    "id": id,
    if(name != null)
    "name": name!,
    if(description != null)
    "description": description!,
    if(billDate != null)
    "bill_date": billDate!.dateToJSONFormat(),
    if(billCycle != null)
    "bill_cycle": billCycle!.convertToJson(),
    if(price != null)
    "price": price!,
    if(currency != null)
    "currency": currency!,
    if(image != null)
    "image": image!,
    if(color != null)
    "color": color.toString()
  };
}

class SubscriptionSort {
  final String sort; //name currency price
  final int sortType; //1 -1

  const SubscriptionSort(this.sort, this.sortType);
}
