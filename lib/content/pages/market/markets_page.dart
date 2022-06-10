import 'package:asset_flutter/content/widgets/market/market_list.dart';
import 'package:asset_flutter/content/widgets/market/market_dropdowns.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';

class MarketsPage extends StatelessWidget {
  const MarketsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Markets", 
          style: TextStyle(fontWeight: FontWeight.bold)
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(1, 8, 1, 0),
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
                child: const MarketDropdowns()
              ),
              const MarketList(),
            ],
          ),
        )
      ),
    );
  }
}