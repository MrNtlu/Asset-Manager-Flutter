import 'package:asset_flutter/content/pages/market/markets_page.dart';
import 'package:asset_flutter/content/pages/portfolio/portfolio_page.dart';
import 'package:asset_flutter/content/pages/settings_page.dart';
import 'package:asset_flutter/content/pages/subscription/subscription_page.dart';
import 'package:asset_flutter/static/purchase_api.dart';
import 'package:asset_flutter/static/token.dart';
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
    }
  }

  final List<Widget> _pages = [
    const MarketsPage(),
    PortfolioPage(),
    SubscriptionPage(),
    SettingsPage()
  ];

  int _selectedPageIndex = 1;

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
        onTap: _selectPage,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedPageIndex,
        elevation: 5,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage("assets/images/markets.png")), label: "Markets"),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money_rounded), label: "Portfolio"),
          BottomNavigationBarItem(
              icon: Icon(Icons.subscriptions_rounded), label: "Subscriptions"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded), label: "Settings"),
        ],
        backgroundColor: Colors.white,
      ),
    );
  }
}
