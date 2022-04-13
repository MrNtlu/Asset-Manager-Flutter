import 'package:asset_flutter/content/widgets/market/market_list.dart';
import 'package:asset_flutter/content/widgets/market/market_dropdowns.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';

class MarketsPage extends StatelessWidget {
  const MarketsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 1),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors().primaryColor,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(24),
                    topLeft: Radius.circular(24)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: MarketDropdowns()
            ),
            MarketList(),
          ],
        ),
      )
    );
  }
}