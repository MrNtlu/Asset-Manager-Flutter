import 'dart:io';
import 'package:asset_flutter/common/widgets/add_elevated_button.dart';
import 'package:asset_flutter/content/pages/subscription/subscription_create_page.dart';
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
            const SliverAppBar(
              expandedHeight: 210,
              floating: true,
              snap: false,
              backgroundColor: Colors.white,
              elevation: 5,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Center(
                  child: SubscriptionCurrencyBar(),
                ),
              ),
            ),
          ]
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              SubscriptionList(),
              Container(
                alignment: Alignment.bottomCenter,
                child: AddElevatedButton("Add Subscription", (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: ((context) => SubscriptionCreatePage()))
                  );
                },
                edgeInsets: const EdgeInsets.only(left: 8, right: 8, bottom: 8)),
              ),
          ])
        ),
      )
      :
      CustomScrollView(
        physics: const ScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: Column(
                children: const [
                  SubscriptionCurrencyBar(),
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