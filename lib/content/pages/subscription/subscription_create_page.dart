import 'package:asset_flutter/content/widgets/portfolio/sd_edit.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';

class SubscriptionCreatePage extends StatelessWidget {
  const SubscriptionCreatePage({Key? key}) : super(key: key);

  void _createSubscription() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Create"),
        backgroundColor: AppColors().primaryLightishColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.save_rounded),
            tooltip: 'Exit Edit State',
            onPressed: _createSubscription,
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SubscriptionDetailsEdit(null),
        ),
      ),
    );
  }
}
