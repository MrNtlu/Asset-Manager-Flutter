import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:asset_flutter/content/providers/settings/theme_state.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/shared_pref.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:asset_flutter/auth/pages/login_page.dart';
import 'package:asset_flutter/auth/pages/register_page.dart';
import 'package:asset_flutter/content/providers/common/currencies.dart';
import 'package:asset_flutter/content/providers/common/currency_sheet_state.dart';
import 'package:asset_flutter/content/providers/common/stats_sheet_state.dart';
import 'package:asset_flutter/content/providers/subscription/card_sheet_state.dart';
import 'package:asset_flutter/content/providers/subscription/card_state.dart';
import 'package:asset_flutter/content/providers/subscription/card_subscriptions.dart';
import 'package:asset_flutter/content/providers/subscription/cards.dart';
import 'package:asset_flutter/content/providers/subscription/subscription_image_selection.dart';
import 'package:asset_flutter/content/providers/subscription/subscription_state.dart';
import 'package:asset_flutter/content/providers/wallet/bank_account_selection_state.dart';
import 'package:asset_flutter/content/providers/wallet/bank_account_state.dart';
import 'package:asset_flutter/content/providers/wallet/bank_accounts.dart';
import 'package:asset_flutter/content/providers/wallet/transaction_calendar.dart';
import 'package:asset_flutter/content/providers/wallet/transaction_sheet_state.dart';
import 'package:asset_flutter/content/providers/wallet/transaction_state.dart';
import 'package:asset_flutter/content/providers/wallet/transaction_stats_toggle.dart';
import 'package:asset_flutter/content/providers/wallet/transaction_total_stat.dart';
import 'package:asset_flutter/content/providers/wallet/transactions.dart';
import 'package:asset_flutter/content/providers/wallet/wallet_state.dart';
import 'package:asset_flutter/static/purchase_api.dart';
import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:asset_flutter/content/providers/asset.dart';
import 'package:asset_flutter/content/providers/asset_details.dart';
import 'package:asset_flutter/content/providers/assets.dart';
import 'package:asset_flutter/content/providers/market/market_selection_state.dart';
import 'package:asset_flutter/content/providers/market/prices.dart';
import 'package:asset_flutter/content/providers/portfolio/daily_stats.dart';
import 'package:asset_flutter/content/providers/portfolio/portfolio_state.dart';
import 'package:asset_flutter/content/providers/common/stats_toggle_state.dart';
import 'package:asset_flutter/content/providers/subscription/subscription_details.dart';
import 'package:asset_flutter/content/providers/subscription/subscriptions.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:flutter/material.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

FirebaseAnalytics analytics = FirebaseAnalytics.instance;
FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;
FirebaseMessaging messaging = FirebaseMessaging.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await PurchaseApi().init();
  await Firebase.initializeApp();
  await SharedPref().init();
  FlutterAppBadger.removeBadge();
  
  setWindowForPC();
  runApp(const MyApp());

  final status = await AppTrackingTransparency.requestTrackingAuthorization();
  final shouldActivateAnalytics = status == TrackingStatus.authorized || status == TrackingStatus.notSupported;

  analytics.setAnalyticsCollectionEnabled(shouldActivateAnalytics);
  crashlytics.setCrashlyticsCollectionEnabled(shouldActivateAnalytics);
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
        ChangeNotifierProvider(create: (context) => SubscriptionsProvider()),
        ChangeNotifierProvider(create: (context) => AssetsProvider()),
        ChangeNotifierProvider(create: (context) => SubscriptionDetailsProvider()),
        ChangeNotifierProvider(create: (context) => AssetProvider()),
        ChangeNotifierProvider(create: (context) => AssetDetailsStateProvider()),
        ChangeNotifierProvider(create: (context) => PortfolioRefreshProvider()),
        ChangeNotifierProvider(create: (context) => PricesProvider()),
        ChangeNotifierProvider(create: (context) => DailyStatsProvider()),
        ChangeNotifierProvider(create: (context) => TransactionTotalStatsProvider()),
        ChangeNotifierProvider(create: (context) => CurrenciesProvider()),
        ChangeNotifierProvider(create: (context) => SubscriptionStateProvider()),
        ChangeNotifierProvider(create: (context) => CardProvider()),
        ChangeNotifierProvider(create: (context) => CardSubscriptionsProvider()),
        ChangeNotifierProvider(create: (context) => SubscriptionImageSelection()),
        ChangeNotifierProvider(create: (context) => TransactionsProvider()),
        ChangeNotifierProvider(create: (context) => BankAccountProvider()),
        ChangeNotifierProvider(create: (context) => TransactionCalendarCountsProvider()),
        ChangeNotifierProvider(create: (context) => CardStateProvider()),
        ChangeNotifierProvider(create: (context) => WalletStateProvider()),
        ChangeNotifierProvider(create: (context) => BankAccountStateProvider()),
        ChangeNotifierProvider(create: (context) => TransactionStateProvider()),
        ChangeNotifierProvider(create: (context) => MarketSelectionStateProvider()),
        ChangeNotifierProvider(create: (context) => StatsToggleSelectionStateProvider()),
        ChangeNotifierProvider(create: (context) => StatsSheetSelectionStateProvider()),
        ChangeNotifierProvider(create: (context) => CurrencySheetSelectionStateProvider()),
        ChangeNotifierProvider(create: (context) => CardSheetSelectionStateProvider()),
        ChangeNotifierProvider(create: (context) => BankAccountSelectionStateProvider()),
        ChangeNotifierProvider(create: (context) => TransactionSheetSelectionStateProvider()),
        ChangeNotifierProvider(create: (context) => TransactionStatsToggleProvider()),
      ],
      child: ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          Provider.of<ThemeProvider>(context);
          return MaterialApp(
            title: 'Kanma',
            theme: AppColors().lightTheme,
            darkTheme: AppColors().darkTheme,
            themeMode: SharedPref().isDarkTheme() ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: LoginPage(),
            routes: {
              LoginPage.routeName: (ctx) => LoginPage(),
              RegisterPage.routeName: (ctx) => RegisterPage(),
              TabsPage.routeName: (ctx) => TabsPage(UserToken().token)
            },
          );
        }
      )
    );
  }
}
