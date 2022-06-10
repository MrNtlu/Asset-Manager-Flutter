import 'package:asset_flutter/content/models/responses/transaction.dart';
import 'package:flutter/material.dart';

enum Category {
  food(0, Icons.fastfood_rounded, Color(0xFFF500BD)),
  shopping(1, Icons.shopping_basket_rounded, Color(0xFF7329DD)),
  transportation(2, Icons.directions_bus_rounded, Color(0xFF37A0FF)),
  entertainment(3, Icons.local_movies_rounded, Color(0xFF3F4BC2)),
  software(4, Icons.terminal_rounded, Color(0xFF237B70)),
  health(5, Icons.emergency_rounded, Color(0xFFF85958)),
  income(6, Icons.attach_money_rounded, Color(0xFFFEA802)),
  others(7, Icons.more_horiz_rounded, Colors.grey);

  const Category(this.value, this.icon, this.iconColor);
  final int value;
  final IconData icon;
  final Color iconColor;

  static Category valueToCategory(int value) {
    switch (value) {
      case 0:
        return food;
      case 1:
        return shopping;
      case 2:
        return transportation;
      case 3:
        return entertainment;
      case 4:
        return software;
      case 5:
        return health;
      case 6:
        return income;
      case 7:
        return others;
      default:
        return food;
    }
  }
}

class Transaction with ChangeNotifier {
  final String id;
  late String title;
  late String? description;
  late int category;
  late num price;
  late String currency;
  late TransactionMethod? transactionMethod;
  late DateTime transactionDate;

  Transaction(this.id, this.title, this.description, this.category, this.price,
      this.currency, this.transactionDate, this.transactionMethod);
}
