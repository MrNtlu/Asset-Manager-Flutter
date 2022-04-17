import 'package:asset_flutter/content/models/responses/subscription.dart';
import 'package:asset_flutter/content/providers/subscription/subscriptions.dart';
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
            color: AppColors().primaryDarkestColor.withAlpha(20),
            spreadRadius: 0, //extend
            blurRadius: 4, //soften
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Card(
        elevation: 2,
        shadowColor: AppColors().primaryDarkestColor,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
          child: Column(
            children: [
              Row(
                children: _currencyBarWidgetList(subscriptionStats),
              ),
              SizedBox(
                height: 70,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  alignment: WrapAlignment.start,
                  spacing: 1,
                  direction: Axis.vertical,
                  children: _currencyBarTitleList(subscriptionStats),
                ),
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