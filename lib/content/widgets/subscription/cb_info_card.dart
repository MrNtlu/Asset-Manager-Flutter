import 'package:asset_flutter/content/models/responses/subscription.dart';
import 'package:asset_flutter/content/providers/subscription/subscriptions.dart';
import 'package:asset_flutter/content/widgets/subscription/cb_container.dart';
import 'package:asset_flutter/content/widgets/subscription/cb_info_text.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/stats_bar.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrencyBarInfoCard extends StatelessWidget {
  final bool _isFirstDropdownSelected;

  const CurrencyBarInfoCard(this._isFirstDropdownSelected, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final subscriptionStatsProvider = Provider.of<SubscriptionsProvider>(context);
    final subscriptionStats = subscriptionStatsProvider.stats;

    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, top: 4),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: AppColors().primaryDarkestColor.withAlpha(20),
            spreadRadius: 0, //extend
            blurRadius: 4, //soften
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Card(
        elevation: 2,
        shadowColor: AppColors().primaryDarkestColor,
        color: AppColors().primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 4),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: AutoSizeText(
                        subscriptionStats[0].monthlyPayment.toString(),
                        softWrap: false,
                        maxLines: 1,
                        maxFontSize: 22,
                        minFontSize: 20,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width > 350 ? 36 : 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          subscriptionStats[0].currency,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: CupertinoButton(
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        color: AppColors().primaryColor,
                        padding: const EdgeInsets.all(6),
                        child: Row(
                          children: const [
                            Icon(Icons.credit_card_rounded, size: 24),
                            Expanded(
                              child: Text(
                                "Cards",
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ), 
                        onPressed: () {
                          //TODO: Implement
                        }
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: CupertinoButton(
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        color: AppColors().primaryColor,
                        padding: const EdgeInsets.all(6),
                        child: Row(
                          children: const [
                            Icon(Icons.bar_chart_rounded, size: 24),
                            Expanded(
                              child: Text(
                                "Statistics",
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ), 
                        onPressed: () {
                          //TODO: Implement
                        }
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _currencyBarTitleList(List<SubscriptionStats> subscriptionStats) {
    final List<Widget> _widgetList = [];

    for (var i = 0; i < subscriptionStats.length; i++){
      final payment = _isFirstDropdownSelected 
        ? subscriptionStats[i].monthlyPayment 
        : subscriptionStats[i].totalPayment;
      
      if (payment > 0) {
        _widgetList.add(
          SubscriptionCurrencyBarInfoText(
            StatsBar().statsColor[_widgetList.length%4],
            "${payment.numToString()} ${subscriptionStats[i].currency}"
          )
        );
      }
    }

    return _widgetList;
  }

  List<Widget> _currencyBarWidgetList(List<SubscriptionStats> subscriptionStats) {
    final List<int> percentageList = [];
    final List<Widget> _widgetList = [];

    for (var index = 0; index < subscriptionStats.length; index++){
      final percentage = StatsBar().subscriptionStatsPercentageCalculator(
        subscriptionStats, 
        _isFirstDropdownSelected 
          ? subscriptionStats[index].monthlyPayment 
          : subscriptionStats[index].totalPayment
      );
      if (percentage > 0) {
        percentageList.add(percentage);
      }
    }


    for (var i = 0; i < percentageList.length; i++) {
      _widgetList.add(
        SubscriptionCurrencyBarContainer(
          percentageList[i], 
          i, 
          StatsBar().statsColor[i%4],
          percentageList.length
        )
      );
    }

    return _widgetList;
  }
}