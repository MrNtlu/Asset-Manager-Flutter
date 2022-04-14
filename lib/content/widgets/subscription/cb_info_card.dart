import 'package:asset_flutter/content/providers/subscriptions.dart';
import 'package:asset_flutter/content/widgets/subscription/cb_container.dart';
import 'package:asset_flutter/content/widgets/subscription/cb_info_text.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/stats_bar.dart';
import 'package:asset_flutter/utils/extensions.dart';
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
      margin: const EdgeInsets.only(left: 8, right: 8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: AppColors().primaryDarkestColor.withAlpha(40),
            spreadRadius: 2, //extend
            blurRadius: 7, //soften
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Card(
        elevation: 8,
        shadowColor: AppColors().primaryDarkestColor,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
          child: Column(
            children: [
              Row(
                children: [
                  for (var index = 0; index < subscriptionStats.length; index++)
                    SubscriptionCurrencyBarContainer(
                      StatsBar().subscriptionStatsPercentageCalculator(
                        subscriptionStats, 
                        _isFirstDropdownSelected ? 
                        subscriptionStats[index].monthlyPayment : 
                        subscriptionStats[index].totalPayment
                      ), 
                      index, 
                      StatsBar().statsColor[index%4],
                      subscriptionStats.length
                    )
                ],
              ),
              SizedBox(
                height: 70,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  alignment: WrapAlignment.start,
                  spacing: 1,
                  direction: Axis.vertical,
                  children: [
                    for (var i = 0; i < subscriptionStats.length; i++)
                    SubscriptionCurrencyBarInfoText(
                      StatsBar().statsColor[i],
                      (_isFirstDropdownSelected ? 
                      subscriptionStats[i].monthlyPayment.numToString() 
                      :
                      subscriptionStats[i].totalPayment.numToString())
                      + ' ' 
                      + subscriptionStats[i].currency
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}