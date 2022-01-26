import 'package:asset_flutter/content/pages/portfolio/portfolio_page.dart';
import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:asset_flutter/content/widgets/portfolio/section_title.dart';
import 'package:asset_flutter/content/widgets/subscription/cb_button.dart';
import 'package:asset_flutter/content/widgets/subscription/cb_container.dart';
import 'package:asset_flutter/content/widgets/subscription/cb_info_text.dart';
import 'package:flutter/material.dart';

class SubscriptionCurrencyBar extends StatelessWidget {
  final List<TestSubscriptionStatsData> _currencyList;

  const SubscriptionCurrencyBar(this._currencyList);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      child: Column(
        children: [
          const SectionTitle("Monthly Payments", "", mainFontSize: 22),
          Container(
            margin: const EdgeInsets.only(left: 8, right: 8),
            child: Card(
              color: TabsPage.primaryLightishColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        for (var index = 0; index < _currencyList.length; index++)
                          SubscriptionCurrencyBarContainer(
                            TestData.subscriptionStatsPercentageCalculator(
                              _currencyList, 
                              _currencyList[index]
                            ), index, TestData.testSubscriptionStatsColor[index%4],
                            _currencyList.length
                          )
                      ],
                    ),
                    SizedBox(
                      height: 35 * (_currencyList.length / 2).ceil().toDouble(),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        alignment: WrapAlignment.start,
                        spacing: 1,
                        direction: Axis.vertical,
                        children: [
                          for (var i = 0; i < _currencyList.length; i++)
                          SubscriptionCurrencyBarInfoText(
                            TestData.testSubscriptionStatsColor[i], 
                            _currencyList[i].totalPayment.toString() + ' ' + _currencyList[i].currency
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: Row(
              children: [
                CurrencyBarButton('Stats', (){
                  print("Stats Pressed");
                }),
                CurrencyBarButton('Cards', (){
                  print("Cards Pressed");
                }),
              ],
            ),
          )
        ],
      ),
    );
  }
}