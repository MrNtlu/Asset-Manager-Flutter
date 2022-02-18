import 'package:asset_flutter/content/providers/asset_stats.dart';
import 'package:asset_flutter/content/widgets/portfolio/pl_text.dart';
import 'package:asset_flutter/content/widgets/portfolio/section_title.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/utils/currency_handler.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Portfolio extends StatelessWidget {
  final bool isDetailed;

  const Portfolio({this.isDetailed = false});

  @override
  Widget build(BuildContext context) {
    final assetStatsProvider = Provider.of<AssetStatsProvider>(context);
    final assetStats = assetStatsProvider.assetStats;
    final currencySymbol = convertCurrencyToSymbol(assetStats!.currency == ''
                        ? 'USD'
                        : assetStats.currency);

    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Column(children: [
        if(!isDetailed) const SectionTitle("Your Portfolio", "", mainFontSize: 22),
        Container(
          margin: const EdgeInsets.only(left: 8, right: 8),
          child: Card(
            color: AppColors().primaryLightishColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      (assetStats.currency == ''
                        ? 'USD'
                        : assetStats.currency) + "($currencySymbol)",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12, left: 8),
                    child: Align(
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        assetStats.totalAsset.numToString(),
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
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: PortfolioPLText(
                      assetStats.totalPL.toDouble(), null, 
                      fontSize: MediaQuery.of(context).size.width > 350 ? 20 : 16, 
                      iconSize: MediaQuery.of(context).size.width > 350 ? 22 : 18,
                      plPrefix: currencySymbol,
                    )
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}