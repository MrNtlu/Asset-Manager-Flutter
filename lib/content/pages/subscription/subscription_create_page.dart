import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/success_view.dart';
import 'package:asset_flutter/content/providers/subscriptions.dart';
import 'package:asset_flutter/content/widgets/portfolio/sd_edit.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionCreatePage extends StatefulWidget {
  @override
  State<SubscriptionCreatePage> createState() => _SubscriptionCreatePageState();
}

class _SubscriptionCreatePageState extends State<SubscriptionCreatePage> {
  bool _isInit = false;
  bool _isLoading = false;
  late final SubscriptionDetailsEdit _subscriptionDetailsEdit;
  late final SubscriptionsProvider _subscriptionsProvider;

  void _setCreateData(){
    _subscriptionDetailsEdit.createData!.billDate = _subscriptionDetailsEdit.datePicker.billDate;
    _subscriptionDetailsEdit.createData!.billCycle = _subscriptionDetailsEdit.billCyclePicker.billCycle;
    _subscriptionDetailsEdit.createData!.color = _subscriptionDetailsEdit.colorPicker.selectedColor.value;
  }

  void _createSubscription(BuildContext context) {
    final isValid = _subscriptionDetailsEdit.form.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    _subscriptionDetailsEdit.form.currentState?.save();
    _setCreateData();

    _subscriptionsProvider.addSubscription(_subscriptionDetailsEdit.createData!).then((value){
      setState(() {
        _isLoading = false;
      });
      if (value.error == null) {
        showDialog(
          barrierColor: Colors.black87,
          context: context,
          barrierDismissible: false,
          builder: (ctx) => const SuccessView("created")
        );
      } else {
        showDialog(
          context: context, 
          builder: (ctx) => ErrorDialog(value.error!)
        );
      }
    }).catchError((error){
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context, 
        builder: (ctx) => ErrorDialog(error.toString())
      );
    });
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _subscriptionsProvider = Provider.of<SubscriptionsProvider>(context, listen: false);
      _subscriptionDetailsEdit = SubscriptionDetailsEdit(null);
    }
    _isInit = true;
    super.didChangeDependencies();
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
            tooltip: 'Save Subscription',
            onPressed: () => _createSubscription(context),
          )
        ],
      ),
      body: SafeArea(
        child: _isLoading 
        ? const LoadingView("Creating Subscription")
        : SingleChildScrollView(
          child: _subscriptionDetailsEdit,
        ),
      ),
    );
  }
}