import 'package:asset_flutter/content/models/subscription.dart';
import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:asset_flutter/content/widgets/portfolio/sd_edit.dart';
import 'package:flutter/material.dart';

class SubscriptionCreatePage extends StatelessWidget {
  const SubscriptionCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Create"),
        backgroundColor: TabsPage.primaryLightishColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.save_rounded),
            tooltip: 'Exit Edit State',
            onPressed: () {
              print("Save");
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SubscriptionDetailsEdit(Subscription.empty()),
        ),
      ),
    );
  }
}
