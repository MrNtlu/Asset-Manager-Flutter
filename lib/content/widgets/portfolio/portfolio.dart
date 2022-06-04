import 'package:asset_flutter/content/providers/assets.dart';
import 'package:asset_flutter/content/widgets/portfolio/pl_text.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Portfolio extends StatelessWidget {
  final bool isDetailed;

  const Portfolio({this.isDetailed = false});

  @override
  Widget build(BuildContext context) {
    final assetStatsProvider = Provider.of<AssetsProvider>(context);
    final assetStats = assetStatsProvider.assetStats;
    final currencySymbol = assetStats!.currency == '' ? 'USD' : assetStats.currency;

    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      margin: const EdgeInsets.only(left: 8, right: 8),
      child: Card(
        color: AppColors().primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 12, top: 12),
                child: Text(
                  "My Portfolio",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 6, left: 12, bottom: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    (assetStats.currency == ''
                      ? 'USD'
                      : assetStats.currency).getCurrencyFromString() + ' ' + assetStats.totalAsset.numToString(),
                    softWrap: false,
                    maxLines: 1,
                    minFontSize: 22,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width > 350 ? 36 : 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              PortfolioPLText(
                assetStats.totalPL.toDouble(),
                assetStats.totalPLPercentage.toDouble(),
                null, 
                fontSize: MediaQuery.of(context).size.width > 350 ? 20 : 16, 
                iconSize: MediaQuery.of(context).size.width > 350 ? 22 : 18,
                plPrefix: currencySymbol.getCurrencyFromString(),
              )
            ],
          ),
        ),
      ),
    );
  }
}