import 'package:asset_flutter/content/providers/subscriptions.dart';
import 'package:asset_flutter/content/widgets/portfolio/section_title.dart';
import 'package:asset_flutter/content/widgets/subscription/sl_cell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final subscriptionsProvider = Provider.of<SubscriptionsProvider>(context);
    final subscriptions = subscriptionsProvider.items;

    return SizedBox(
      child: Column(
        children: [
          const SectionTitle("Subscriptions", "",),
          Expanded(
            child: ListView.builder(itemBuilder: ((context, index) {
              if(index == subscriptions.length) {
                return const SizedBox(height: 75);
              }
              final data = subscriptions[index];
              return ChangeNotifierProvider.value(
                value: data,
                child: SubscriptionListCell()
              );
            }),
            itemCount: subscriptions.length + 1,
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}