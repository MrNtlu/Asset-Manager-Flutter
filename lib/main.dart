import 'dart:io';

import 'package:asset_flutter/auth/pages/login_page.dart';
import 'package:asset_flutter/auth/pages/register_page.dart';
import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:asset_flutter/content/providers/asset.dart';
import 'package:asset_flutter/content/providers/asset_details.dart';
import 'package:asset_flutter/content/providers/asset_logs.dart';
import 'package:asset_flutter/content/providers/assets.dart';
import 'package:asset_flutter/content/providers/market/market_selection_state.dart';
import 'package:asset_flutter/content/providers/market/prices.dart';
import 'package:asset_flutter/content/providers/portfolio_state.dart';
import 'package:asset_flutter/content/providers/subscription_details.dart';
import 'package:asset_flutter/content/providers/subscriptions.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:flutter/material.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

FirebaseAnalytics analytics = FirebaseAnalytics.instance;
FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

void main() {
  setWindowForPC();
  runApp(const MyApp());
}

Future setWindowForPC() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isMacOS) {
    const minSize = Size(525, 850);
    DesktopWindow.setMinWindowSize(minSize);
    DesktopWindow.setWindowSize(minSize);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: SubscriptionsProvider()),
        ChangeNotifierProvider.value(value: AssetLogProvider()),
        ChangeNotifierProvider.value(value: AssetsProvider()),
        ChangeNotifierProvider.value(value: SubscriptionDetailsProvider()),
        ChangeNotifierProvider.value(value: AssetProvider()),
        ChangeNotifierProvider.value(value: AssetDetailsStateProvider()),
        ChangeNotifierProvider.value(value: PortfolioStateProvider()),
        ChangeNotifierProvider.value(value: MarketSelectionStateProvider()),
        ChangeNotifierProvider.value(value: PricesProvider()),
      ],
      child: MaterialApp(
        title: 'Kantan',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
        routes: {
          LoginPage.routeName: (ctx) => LoginPage(),
          RegisterPage.routeName: (ctx) => RegisterPage(),
          TabsPage.routeName: (ctx) => TabsPage(UserToken().token)
        },
      ),
    );
  }
}
