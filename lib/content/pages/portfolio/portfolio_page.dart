import 'dart:io';

import 'package:asset_flutter/common/widgets/add_elevated_button.dart';
import 'package:asset_flutter/content/models/responses/asset.dart';
import 'package:asset_flutter/content/models/responses/subscription.dart';
import 'package:asset_flutter/content/widgets/portfolio/investment_list.dart';
import 'package:asset_flutter/content/widgets/portfolio/portfolio.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PortfolioPage extends StatelessWidget {
  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light),
      child: SafeArea(
        child: MediaQuery.of(context).orientation == Orientation.portrait || Platform.isMacOS || Platform.isWindows ? 
          NestedScrollView(
            floatHeaderSlivers: false,
            headerSliverBuilder: ((context, innerBoxIsScrolled) => [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.height > 600 ? 420 : 400,
                  floating: true,
                  snap: false,
                  backgroundColor: Colors.white,
                  elevation: 5,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Center(
                      child: Column(
                        children: const [
                          Portfolio(),
                          PortfolioStats(false),
                        ],
                      ),
                    ),
                  ),
                ),
              ]
            ),
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  PortfolioInvestment(),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: AddElevatedButton("Add Investment", (){
                      print("Add Investment");
                    },
                    edgeInsets: const EdgeInsets.only(left: 8, right: 8, bottom: 8)),
                  ),
                ],
              )
            )
          )
          : 
          CustomScrollView(
            physics: const ScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      children: [
                        const Portfolio(),
                        const PortfolioStats(false),
                        PortfolioInvestment(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ),
    );
  }
}

class TestData {
  static List<AssetDetails> testInvestData = [
    const AssetDetails(300.0, 'Bitcoin', 'BTC', 'USD', 'crypto', -68.28, 0.00062),
    const AssetDetails(25.0, 'Polygon', 'MATIC', 'USD', 'crypto', 40.67, 105.2),
    const AssetDetails(167.2, 'Loopspring', 'LRC', 'USD', 'crypto', 140.67, 50.0),
    const AssetDetails(217.53, 'Apple Inc.', 'AAPL', 'USD', 'stock', 5.78, 35.2),
    const AssetDetails(78.4, 'Intel', 'INTC', 'USD', 'stock', -20.5, 3.6),
    const AssetDetails(59.21, 'Olin Corporation', 'OLN', 'USD', 'stock', 3.9, 10.2),
    const AssetDetails(107.32, 'Audius', 'AUDIO', 'GBP', 'crypto', -120.5, 325.6),
    const AssetDetails(45.9, 'Avalanche', 'AVAX', 'USD', 'crypto', 34.2, 34.7),
    const AssetDetails(45.9, 'Litecoin', 'LTC', 'USD', 'crypto', 34.2, 34.7),
    const AssetDetails(45.9, 'Amazon.com, Inc.', 'AMZN', 'USD', 'stock', 34.2, 34.7),
    const AssetDetails(45.9, 'Activision Blizzard, Inc.', 'ATVI', 'USD', 'stock', 34.2, 34.7),
    const AssetDetails(45.9, 'Ethereum Classic', 'ETC', 'USD', 'crypto', 34.2, 34.7),
  ];

  static List<SubscriptionStats> testSubscriptionStatsData = [
    const SubscriptionStats('USD', 43.8, 60.9),
    const SubscriptionStats('EUR', 85.3, 85.3),
    const SubscriptionStats('TRY', 380, 989.9),
    const SubscriptionStats('GBP', 30.1, 120.6),
  ];

  static AssetStats testAssetStatsData = AssetStats("GBP", 130, 45, 120, 536.28, 102.4, 756.46, 42202.7, -66542.5, -125324.6, -150684.46, 17.5, 67.66, 14.84);

  static List<AssetLog> testInvestLogData = [
    AssetLog(475.2855, "BTC", "USD", "buy", 0.01, DateTime.now(), boughtPrice: 47528.55),
    AssetLog(348.062, "BTC", "USD", "buy", 0.006, DateTime.now().subtract(const Duration(days: 3)), boughtPrice: 58001.27),
    AssetLog(252, "BTC", "USD", "sell", 0.000782, DateTime.now(), soldPrice: 53582.55),
    AssetLog(93.084, "BTC", "USD", "buy", 0.0015, DateTime.now().subtract(const Duration(days: 33)), boughtPrice: 62056),
    AssetLog(252, "BTC", "USD", "sell", 0.000782, DateTime.now(), soldPrice: 53582.55),
    AssetLog(102.3, "BTC", "USD", "sell", 0.00313, DateTime.now(), soldPrice: 35528.55),
    AssetLog(93.084, "BTC", "USD", "buy", 0.0015, DateTime.now().subtract(const Duration(days: 67)), boughtPrice: 62056),
    AssetLog(102.3, "BTC", "USD", "sell", 0.00313, DateTime.now(), soldPrice: 35528.55),
    AssetLog(93.084, "BTC", "USD", "buy", 0.0015, DateTime.now().subtract(const Duration(days: 395)), boughtPrice: 62056),
    AssetLog(102.3, "BTC", "USD", "sell", 0.00313, DateTime.now().subtract(const Duration(days: 462)), soldPrice: 35528.55),
  ];

  static String stockImage(String symbol) {
    return "https://storage.googleapis.com/iex/api/logos/${symbol.toUpperCase()}.png";
  }

  static String cryptoImage(String symbol) {
    return "https://raw.githubusercontent.com/spothq/cryptocurrency-icons/master/32@2x/color/${symbol.toLowerCase()}@2x.png";
  }

  static String cryptoFailImage() {
    return "https://raw.githubusercontent.com/spothq/cryptocurrency-icons/master/32@2x/color/generic@2x.png";
  }

  static IconData subscriptionFailIcon(){
    return Icons.payment_rounded;
  }
}