import 'package:asset_flutter/content/pages/portfolio_page.dart';
import 'package:asset_flutter/content/pages/settings_page.dart';
import 'package:asset_flutter/content/pages/subscription_page.dart';
import 'package:flutter/material.dart';

//TODO: Remove hard color codes and put colors in appropriate place
class TabsPage extends StatefulWidget {
  static const primaryColor = Color(0xFF1a1b4b);
  static const orangeColor = Color(0xFFF57C00);
  static const blueColor = Color(0xFF54C4F8);
  static const darkBlueColor = Color(0xFF00579B);
  static const darkestBlueColor = Color(0xFF00355E);
  static const greenColor = Color(0xFF00C853);
  static const redColor = Color(0xFFD32F2F);
  static const blueGreyColor = Color(0xFF263238);

  static const routeName = "/tabs";
  final String token;

  const TabsPage(this.token);

  @override
  _TabsPage createState() => _TabsPage();
}

class _TabsPage extends State<TabsPage> {
  final List<Widget> _pages = [
    PortfolioPage(),
    SubscriptionPage(),
    SettingsPage()
  ];

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Token is " + widget.token);

    return Scaffold(
      body: _pages[_selectedPageIndex],
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        currentIndex: _selectedPageIndex,
        elevation: 5,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money_rounded), label: "Portfolio"),
          BottomNavigationBarItem(
              icon: Icon(Icons.subscriptions_rounded), label: "Subscriptions"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded), label: "Settings"),
        ],
        backgroundColor: TabsPage.darkBlueColor,
      ),
    );
  }
}
