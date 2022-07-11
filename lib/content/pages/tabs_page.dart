import 'package:asset_flutter/content/pages/wallet/wallet_page.dart';
import 'package:asset_flutter/content/pages/portfolio/portfolio_page.dart';
import 'package:asset_flutter/content/pages/settings/settings_page.dart';
import 'package:asset_flutter/content/pages/subscription/subscription_page.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/purchase_api.dart';
import 'package:asset_flutter/static/shared_pref.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/fcm.dart';
import 'package:flutter/material.dart';

class TabsPage extends StatefulWidget {
  static const routeName = "/tabs";

  TabsPage(token) {
    UserToken().setToken = token;
  }

  @override
  _TabsPage createState() => _TabsPage();
}

class _TabsPage extends State<TabsPage> {
  bool isInit = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!isInit) {
      await PurchaseApi().userInit();
      final firebaseMessaging = FCM();
      await firebaseMessaging.init();
      firebaseMessaging.setNotifications();
    }
  }

  final List<Widget> _pages = const [
    PortfolioPage(),
    SubscriptionPage(),
    WalletPage(),
    SettingsPage()
  ];

  int _selectedPageIndex = SharedPref().getDefaultTab();

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex],
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _selectPage,
        selectedItemColor: Theme.of(context).colorScheme.bottomBarSelectedTextColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Theme.of(context).colorScheme.bottomBarBgColor,
        currentIndex: _selectedPageIndex,
        elevation: 8,
        enableFeedback: true,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money_rounded), label: "Portfolio"),
          BottomNavigationBarItem(
              icon: Icon(Icons.subscriptions_rounded), label: "Subscriptions"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_rounded), label: "Wallet"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded), label: "Settings"),
        ],
      ),
    );
  }
}
