import 'package:asset_flutter/common/models/json_convert.dart';
import 'package:asset_flutter/content/models/responses/transaction.dart';

class TransactionCreate implements JSONConverter {
  String title;
  String? description;
  int category;
  num price;
  String currency;
  TransactionMethod? transactionMethod;
  DateTime transactionDate;

  TransactionCreate(
    this.title, this.category, this.price, this.currency, this.transactionDate,
    {this.description, this.transactionMethod});
    
  @override
  Map<String, Object> convertToJson() => {
    "title": title,
    if(description != null)
    "description": description!,
    "category": category,
    "price": price,
    "currency": currency,
    if(transactionMethod != null)
    "method": transactionMethod!,
    "transaction_date": transactionDate
  };
}

class TransactionUpdate implements JSONConverter {
  final String id;
  String? title;
  String? description;
  int? category;
  num? price;
  String? currency;
  TransactionMethod? transactionMethod;
  DateTime? transactionDate;

  TransactionUpdate(this.id,
    {this.title, this.category, this.price, this.currency, 
    this.transactionDate, this.description, this.transactionMethod});
    
  @override
  Map<String, Object> convertToJson() => {
    "id": id,
    if(title != null)
    "title": title!,
    if(description != null)
    "description": description!,
    if(category != null)
    "category": category!,
    if(price != null)
    "price": price!,
    if(currency != null)
    "currency": currency!,
    if(transactionMethod != null)
    "method": transactionMethod!,
    if(transactionDate != null)
    "transaction_date": transactionDate!
  };
}

class TransactionSortFilter {
  final String? category;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? bankAccID;
  final String? cardID;
  final int page;
  final String sort;
  final int sortType;

  const TransactionSortFilter(this.page, this.sort, this.sortType, {
    this.category,
    this.startDate,
    this.endDate,
    this.bankAccID,
    this.cardID
  });
}

class TransactionTotalInterval {
  final String interval; //day month
  final DateTime transactionDate; 

  const TransactionTotalInterval(this.interval, this.transactionDate);
}

class TransactionStatsInterval {
  final String interval; //weekly monthly

  const TransactionStatsInterval(this.interval);
}
