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

  AppColors._privateConstructor();

  static final AppColors _instance = AppColors._privateConstructor();

  factory AppColors() {
    return _instance;
  }
}
