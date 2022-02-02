import 'dart:io';

import 'package:asset_flutter/content/pages/portfolio/portfolio_page.dart';
import 'package:asset_flutter/content/widgets/subscription/currency_bar.dart';
import 'package:asset_flutter/content/widgets/subscription/subscription_list.dart';
import 'package:flutter/material.dart';

class SubscriptionPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MediaQuery.of(context).orientation == Orientation.portrait || Platform.isMacOS || Platform.isWindows  ?
      NestedScrollView(
        floatHeaderSlivers: false,
        headerSliverBuilder: ((context, innerBoxIsScrolled) => [
            SliverAppBar(
              expandedHeight: 210,
              floating: true,
              snap: false,
              backgroundColor: Colors.white,
              elevation: 5,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Center(
                  child: SubscriptionCurrencyBar(TestData.testSubscriptionStatsData),
                ),
              ),
            ),
          ]
        ),
        body: SubscriptionList(),
      )
      :
      CustomScrollView(
        physics: const ScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: Column(
                children: [
                  SubscriptionCurrencyBar(TestData.testSubscriptionStatsData),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: SubscriptionList(),
          )
        ]
      )
    );
  }
}