import 'package:flutter/material.dart';

class AppColors {
  final primaryColor = const Color(0xFF00579B);
  final primaryDarkestColor = const Color(0xFF00355E);
  final primaryLightishColor = const Color(0xFF0077D3);
  final primaryLightColor = const Color(0xFF54C4F8);
  final secondaryColor = const Color(0xFF83FEEB);
  final lightBlack = const Color(0xFF595B62);
  final accentColor = const Color(0xFFF454Cf);
  final greenColor = const Color(0xFF66BB6A);
  final redColor = const Color(0xFFEE8582);
  final orangeColor = const Color(0xFFF57C00);
  final barCardColor = const Color(0xff020227);

  AppColors._privateConstructor();

  static final AppColors _instance = AppColors._privateConstructor();

  factory AppColors() {
    return _instance;
  }
}

class SubscriptionColors {
  List<Color> subscriptionColors = [
    Colors.black,
    const Color(0xFF595B62),
    Colors.blue.shade900,
    Colors.blue,
    Colors.blue.shade300,
    Colors.orange.shade900,
    Colors.orange,
    Colors.orange.shade300,
    Colors.yellow.shade600,
    Colors.pink.shade900,
    Colors.pink,
    Colors.pink.shade300,
    Colors.purple.shade900,
    Colors.purple,
    Colors.purple.shade300,
    Colors.red.shade900,
    Colors.red,
    Colors.red.shade300,
    Colors.green.shade900,
    Colors.green,
    Colors.green.shade300,
    Colors.grey,
    Colors.grey.shade700,
    Colors.brown.shade900,
    Colors.brown,
    Colors.brown.shade300,
  ];

  SubscriptionColors._privateConstructor();

  static final SubscriptionColors _instance = SubscriptionColors._privateConstructor();

  factory SubscriptionColors() {
    return _instance;
  }
}
