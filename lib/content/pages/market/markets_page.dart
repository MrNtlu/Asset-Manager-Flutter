import 'package:asset_flutter/content/pages/market/market_list.dart';
import 'package:asset_flutter/content/widgets/market/market_dropdowns.dart';
import 'package:flutter/material.dart';

class MarketsPage extends StatelessWidget {
  const MarketsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            const MarketDropdowns(),
            MarketList(),
          ],
        ),
      )
    );
  }
}