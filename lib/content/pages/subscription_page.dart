import 'dart:io';

import 'package:asset_flutter/content/pages/portfolio_page.dart';
import 'package:asset_flutter/content/widgets/portfolio/section_title.dart';
import 'package:asset_flutter/content/widgets/subscription/currency_bar.dart';
import 'package:flutter/material.dart';

class SubscriptionPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MediaQuery.of(context).orientation == Orientation.portrait || Platform.isMacOS || Platform.isWindows  ?
      CustomScrollView(
        physics: const ScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
                    child: Column(
                      children: [
                        const SectionTitle("Monthly Payments", "", mainFontSize: 22),
                        SubscriptionCurrencyBar(TestData.testSubscriptionStatsData),
                        const SectionTitle("Subscriptions", "See All>"),
                        SizedBox(
                          height: 95,
                          child: ListView.builder(itemBuilder: ((context, index) {
                            final data = TestData.testSubscriptionData[index];
                            return Card(
                              elevation: 4,
                              color: Color(data.color),
                              margin: const EdgeInsets.only(left: 16, bottom: 8, right: 4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  data.image != null ? 
                                  Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: const BoxDecoration(
                                      color: Colors.white, 
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(24),
                                      )
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: SizedBox.fromSize(
                                        size: const Size.fromRadius(24),
                                        child: Image.network(
                                          data.image!,
                                          width: 48,
                                          height: 48,
                                          fit: BoxFit.contain,
                                        ) 
                                      ),
                                    ),
                                  )
                                  : 
                                  Icon(TestData.subscriptionFailIcon()),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(4, 8, 8, 0),
                                          child: Text(
                                            data.name,
                                            maxLines: 2,
                                            softWrap: true,
                                            overflow: TextOverflow.fade,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            )
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.bottomRight,
                                            margin: const EdgeInsets.all(8),
                                            child: Text(
                                              data.price.toString() + ' ' + data.currency,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold
                                              )
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          itemExtent: 230,
                          itemCount: TestData.testSubscriptionData.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          ),
                        ),
                        const SectionTitle("Credit Cards", "See All>"),
                        const SectionTitle("Credit Cards", "See All>"),
                      ],
                    )
                  )
                ],
              ),
            ),
          ),
        ]
      )
      :
      Container(
        child: const Text("Horizontal"),
      )
    );
  }
}