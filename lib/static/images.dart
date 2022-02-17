import 'package:flutter/material.dart';

class PlaceholderImages {
  PlaceholderImages._privateConstructor();

  static final PlaceholderImages _instance = PlaceholderImages._privateConstructor();

  factory PlaceholderImages() {
    return _instance;
  }

  String stockImage(String symbol) {
    return "https://storage.googleapis.com/iex/api/logos/${symbol.toUpperCase()}.png";
  } 

  String cryptoImage(String symbol) {
    return "https://raw.githubusercontent.com/spothq/cryptocurrency-icons/master/32@2x/color/${symbol.toLowerCase()}@2x.png";
  }

  String exchangeImage(String symbol){
    return "https://raw.githubusercontent.com/cychiang/currency-icons/master/icons/currency/${symbol.toLowerCase()}.png";
  }

  String cryptoFailImage() {
    return "https://raw.githubusercontent.com/spothq/cryptocurrency-icons/master/32@2x/color/generic@2x.png";
  }

  IconData subscriptionFailIcon(){
    return Icons.payment_rounded;
  }

  IconData exchangeFailIcon(){
    return Icons.attach_money_rounded;
  }
  IconData stockFailIcon(){
    return Icons.price_change_rounded;
  }
}