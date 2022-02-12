import 'package:asset_flutter/content/models/responses/subscription.dart';

class SubscriptionCreate {
  String? cardID;
  String name;
  String? description;
  late DateTime billDate;
  BillCycle billCycle;
  double price;
  String currency;
  String? image;
  int color;

  SubscriptionCreate(
    this.name, this.billCycle, this.billDate,
    this.price, this.currency, this.image, this.color,
    {this.cardID, this.description}
  );
}

class SubscriptionUpdate {
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

  SubscriptionUpdate(
    this.id, {this.name, this.description, this.billDate, this.billCycle, 
    this.price, this.currency, this.cardID, this.image, this.color}
  );
}

class SubscriptionSort {
  final String sort; //name currency price
  final int sortType; //1 -1

  const SubscriptionSort(this.sort, this.sortType);
}