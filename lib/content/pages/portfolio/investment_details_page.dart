import 'package:asset_flutter/content/pages/portfolio/portfolio_page.dart';
import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:flutter/material.dart';

class InvestmentDetailsPage extends StatelessWidget {
  final TestInvestData data;

  const InvestmentDetailsPage(this.data);

  @override
  Widget build(BuildContext context) {
    final AppBar appBar = AppBar(
      title: Text(data.symbol),
      backgroundColor: TabsPage.primaryLightishColor,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            
          },
          label: const Text('Add Investment', style: TextStyle(fontSize: 18)),
          icon: const Icon(Icons.add_circle, size: 22),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
        ),
        ),
      ),
    );
  }
}
