import 'package:asset_flutter/content/models/responses/subscription.dart';

class SubscriptionCreate {
  final String? cardID;
  final String name;
  final String? description;
  final BillCycle billCycle;
  final double price;
  final String currency;
  final String? image;
  final int color;

  SubscriptionCreate(
    this.name, this.billCycle, 
    this.price, this.currency, this.image, this.color,
    {this.cardID, this.description}
  );
}

class SubscriptionUpdate {
  final String id;
  final String? name;
  final String? description;
  final DateTime? billDate;
  final BillCycle? billCycle;
  final double? price;
  final String? currency;
  final String? cardID;
  final String? image;
  final int? color;

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