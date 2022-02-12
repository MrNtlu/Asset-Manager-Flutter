import 'package:asset_flutter/content/providers/subscriptions.dart';
import 'package:asset_flutter/content/widgets/portfolio/sd_edit.dart';
import 'package:asset_flutter/content/widgets/portfolio/sd_view.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionDetailsPage extends StatefulWidget {
  final String _subscriptionID;

  const SubscriptionDetailsPage(
    this._subscriptionID, {Key? key}
  ): super(key: key);

  @override
  State<SubscriptionDetailsPage> createState() => _SubscriptionDetailsPageState();
}

class _SubscriptionDetailsPageState extends State<SubscriptionDetailsPage> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    final subscriptionsProvider = Provider.of<Subscriptions>(context, listen: false);
    final data = subscriptionsProvider.findById(widget._subscriptionID);

    SubscriptionDetailsEdit updateView = SubscriptionDetailsEdit(data);
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(_isEditing ? "Edit" : ''),
        backgroundColor: AppColors().primaryLightishColor,
        actions: [
          !_isEditing
              ? IconButton(
                  icon: const Icon(Icons.edit_rounded),
                  tooltip: 'Enter Edit State',
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.save_rounded),
                  tooltip: 'Exit Edit State',
                  onPressed: () {
                    setState(() {
                      final isValid = updateView.form.currentState?.validate();
                      if (isValid != null && !isValid) {
                        return;
                      }
                      updateView.form.currentState?.save();
                      if (data.billDate.compareTo(updateView.datePicker.billDate) != 0) {
                        updateView.updateData!.billDate = updateView.datePicker.billDate;
                      }
                      if (data.billCycle != updateView.billCyclePicker.billCycle) {
                        updateView.updateData!.billCycle = updateView.billCyclePicker.billCycle;
                      }
                      if (data.color != updateView.colorPicker.selectedColor.value) {
                        updateView.updateData!.color = updateView.colorPicker.selectedColor.value;
                      }

                      data.updateSubscription(updateView.updateData!);
                      _isEditing = false;
                    });
                  },
                )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: !_isEditing
                ? SubscriptionDetailsView(data)
                : updateView),
      ),
    );
  }
}
