import 'package:flutter/material.dart';

extension ColorSchemeExt on ColorScheme {
  Color get bgColor => brightness == Brightness.dark ? Colors.black : Colors.white;
  Color get bgTextColor => brightness == Brightness.dark ? Colors.white : Colors.black;

  Color get toggleColor => brightness == Brightness.light ? Colors.black : Colors.white;
  Color get toggleTextColor => brightness == Brightness.light ? Colors.white : Colors.black;

  Color get bottomBarSelectedTextColor => brightness == Brightness.light ? Colors.black : Colors.white;
  Color get bottomBarBgColor => brightness == Brightness.light ? Colors.white : Colors.black;

  Color get bgTransparentColor => brightness == Brightness.dark ? Colors.white54: Colors.black38;
}

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

  final bgPrimary = const Color(0xFF051B74);
  final bgSecondary = const Color(0xFF2E0BA0);
  final bgAccent = const Color(0xFFF500BD);

  final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    backgroundColor: Colors.black,
    primaryColor: const Color(0xFF00579B),
    colorScheme: const ColorScheme.dark(primary: Color(0xff007aff)),
    dividerColor: Colors.white38,
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      modalBackgroundColor: Color(0xFF1E1E1E),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Color(0xFF1E1E1E),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20
      )
    )
  );

  final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    primaryColor: const Color(0xFF00579B),
    colorScheme: const ColorScheme.light(primary: Color(0xff007aff)),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      modalBackgroundColor: Colors.white,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      fillColor: Colors.white
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20
      )
    )
  );

  AppColors._privateConstructor();

  static final AppColors _instance = AppColors._privateConstructor();

  factory AppColors() {
    return _instance;
  }
}

class CardColors {
  List<Color> cardColors = [
    const Color(0xFF292D32),
    const Color(0xFFF85958),
    const Color(0xFF7329DD),
    const Color(0xFF37A0FF),
    const Color(0xFF3F4BC2),
    const Color(0xFF237B70),
    const Color(0xFFFEA802),
    const Color(0xFF8A8B91),
  ];

  CardColors._privateConstructor();

  static final CardColors _instance = CardColors._privateConstructor();

  factory CardColors() {
    return _instance;
  }
}

class WatchlistColors {
  List<Color> watchlistColors = [
    const Color(0xFF292D32),
    const Color(0xFFF85958),
    const Color(0xFF7329DD),
    const Color(0xFF37A0FF),
    const Color(0xFF3F4BC2),
    const Color(0xFF237B70),
    const Color(0xFFFEA802),
    const Color(0xFF8A8B91),
  ];

  WatchlistColors._privateConstructor();

  static final WatchlistColors _instance = WatchlistColors._privateConstructor();

  factory WatchlistColors() {
    return _instance;
  }
}

class PortfolioColors {
  List<Color> portfolioColors = [
    const Color(0xFF292D32),
    const Color(0xFF00355E),
    const Color(0xFF00579B),
    const Color(0xFF3F4BC2),
    const Color(0xFF9575CD),
    const Color(0xFF7329DD),
    const Color(0xFF237B70),
    const Color(0xFFFDD835),
    const Color(0xFF37474F),
    const Color(0xFF8A8B91),
  ];

  PortfolioColors._privateConstructor();

  static final PortfolioColors _instance = PortfolioColors._privateConstructor();

  factory PortfolioColors() {
    return _instance;
  }
}

class SubscriptionColors {
  List<Color> subscriptionColors = [
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
