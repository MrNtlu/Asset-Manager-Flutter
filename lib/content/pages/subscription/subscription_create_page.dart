import 'package:asset_flutter/content/providers/subscriptions.dart';
import 'package:asset_flutter/content/widgets/portfolio/sd_edit.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionCreatePage extends StatelessWidget {
  late final SubscriptionDetailsEdit _subscriptionDetailsEdit;
  late final Subscriptions _subscriptionsProvider;

  void _createSubscription() {
    final isValid = _subscriptionDetailsEdit.form.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }
    _subscriptionDetailsEdit.form.currentState?.save();
    _subscriptionsProvider.addSubscription(_subscriptionDetailsEdit.createData!);
  }

  @override
  Widget build(BuildContext context) {
    _subscriptionsProvider = Provider.of<Subscriptions>(context);
    _subscriptionDetailsEdit = SubscriptionDetailsEdit(null);

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
          child: _subscriptionDetailsEdit,
        ),
      ),
    );
  }
}
