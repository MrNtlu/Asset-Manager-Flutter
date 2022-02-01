import 'package:asset_flutter/content/pages/portfolio/portfolio_page.dart';
import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:asset_flutter/content/widgets/portfolio/pl_text.dart';
import 'package:asset_flutter/content/widgets/portfolio/section_title.dart';
import 'package:flutter/material.dart';

class Portfolio extends StatelessWidget {
  final bool isDetailed;

  const Portfolio({this.isDetailed = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Column(children: [
        if(!isDetailed) const SectionTitle("Your Portfolio", "", mainFontSize: 22),
        Container(
          margin: const EdgeInsets.only(left: 8, right: 8),
          child: Card(
            color: TabsPage.primaryLightishColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          TestData.testAssetStatsData.totalAsset.toString(),
                          softWrap: false,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width > 350 ? 36 : 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            TestData.testAssetStatsData.currency,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: PortfolioPLText(
                      TestData.testAssetStatsData.totalPL, 
                      TestData.testAssetStatsData.currency, 
                      fontSize: MediaQuery.of(context).size.width > 350 ? 20 : 16, 
                      iconSize: MediaQuery.of(context).size.width > 350 ? 22 : 18
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