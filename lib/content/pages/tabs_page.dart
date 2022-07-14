import 'package:asset_flutter/content/pages/wallet/wallet_page.dart';
import 'package:asset_flutter/content/pages/portfolio/portfolio_page.dart';
import 'package:asset_flutter/content/pages/settings/settings_page.dart';
import 'package:asset_flutter/content/pages/subscription/subscription_page.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/purchase_api.dart';
import 'package:asset_flutter/static/shared_pref.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/fcm.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
  late final FCM _firebaseMessaging;
  bool _isNotificationRedirected = false;
  int _selectedPageIndex = SharedPref().getDefaultTab();

  Future setupInteractedMessage() async {
    RemoteMessage? initialMessage = await _firebaseMessaging.firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    final dynamic _type;
    final dynamic _id;
    
    try {
      _type = message.data['type'];
      _id = message.data['id'];
    } catch (error) {
      return;
    }

    if (_type == null) {
      return;
    }
    
    setState(() {
      switch (_type) {
        case "subscription":
          _selectedPageIndex = 1;
          _pages[1] = SubscriptionPage(notificationId: _id);
          _isNotificationRedirected = true;
          break;
      }
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!isInit) {
      await PurchaseApi().userInit();
      _firebaseMessaging = FCM();
      await _firebaseMessaging.init();
      await setupInteractedMessage();
      _firebaseMessaging.setNotifications();
      isInit = true;
    }
  }

  final List<Widget> _pages = [
    const PortfolioPage(),
    const SubscriptionPage(),
    const WalletPage(),
    const SettingsPage()
  ];

  void _selectPage(int index) {
    if (_isNotificationRedirected) {
      _pages[1] = const SubscriptionPage();
      _isNotificationRedirected = false;
    }

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
            icon: Icon(Icons.attach_money_rounded), 
            label: "Portfolio"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions_rounded), 
            label: "Subscriptions"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_rounded),
            label: "Wallet"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: "Settings"
          ),
        ],
      ),
    );
  }
}
