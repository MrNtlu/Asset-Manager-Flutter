import 'package:asset_flutter/content/pages/portfolio_page.dart';
import 'package:asset_flutter/content/pages/settings_page.dart';
import 'package:asset_flutter/content/pages/subscription_page.dart';
import 'package:flutter/material.dart';

//TODO: Remove hard color codes and put colors in appropriate place
class TabsPage extends StatefulWidget {
  static const primaryColor = Color(0xFF00579B);
  static const primaryDarkestColor = Color(0xFF00355E);
  static const primaryLightishColor = Color(0xFF0077D3);
  static const primaryLightColor = Color(0xFF54C4F8);
  static const secondaryColor = Color(0xFF83FEEB);
  static const lightBlack = Color(0xFF595B62);
  static const accentColor = Color(0xFFF454Cf);
  static const greenColor = Color(0xFF66BB6A);
  static const redColor = Color(0xFFC62828);
  static const orangeColor = Color(0xFFF57C00);

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
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
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
        backgroundColor: Colors.white,
      ),
    );
  }
}
