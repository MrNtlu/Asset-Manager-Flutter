import 'package:asset_flutter/content/pages/portfolio/portfolio_page.dart';
import 'package:asset_flutter/content/widgets/portfolio/section_title.dart';
import 'package:asset_flutter/content/widgets/subscription/sl_cell.dart';
import 'package:flutter/material.dart';

class SubscriptionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          const SectionTitle("Subscriptions", "",),
          Expanded(
            child: ListView.builder(itemBuilder: ((context, index) {
              if(index == TestData.testSubscriptionData.length) {
                return const SizedBox(height: 75);
              }
              final data = TestData.testSubscriptionData[index];
              return SubscriptionListCell(data);
            }),
            itemCount: TestData.testSubscriptionData.length + 1,
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}