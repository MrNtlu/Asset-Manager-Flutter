import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/premium_dialog.dart';
import 'package:asset_flutter/common/widgets/success_view.dart';
import 'package:asset_flutter/content/providers/subscription/subscription_state.dart';
import 'package:asset_flutter/content/providers/subscription/subscriptions.dart';
import 'package:asset_flutter/content/widgets/subscription/sd_edit.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionCreatePage extends StatefulWidget {
  @override
  State<SubscriptionCreatePage> createState() => _SubscriptionCreatePageState();
}

class _SubscriptionCreatePageState extends State<SubscriptionCreatePage> {
  CreateState _state = CreateState.init;
  late final SubscriptionDetailsEdit _subscriptionDetailsEdit;
  late final SubscriptionsProvider _subscriptionsProvider;
  late final SubscriptionStateProvider _subscriptionStateProvider;

  void _setCreateData(){
    _subscriptionDetailsEdit.createData!.billDate = _subscriptionDetailsEdit.datePicker.billDate;
    _subscriptionDetailsEdit.createData!.billCycle = _subscriptionDetailsEdit.billCyclePicker.billCycle;
    _subscriptionDetailsEdit.createData!.color = _subscriptionDetailsEdit.colorPicker.selectedColor.value;
    _subscriptionDetailsEdit.createData!.image = _subscriptionDetailsEdit.selectedDomain;
    _subscriptionDetailsEdit.createData!.cardID = _subscriptionDetailsEdit.selectedCard?.id;
  }

  void _createSubscription(BuildContext context) {
    final isValid = _subscriptionDetailsEdit.form.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }
    setState(() {
      _state = CreateState.loading;
    });

    _subscriptionDetailsEdit.form.currentState?.save();
    _setCreateData();

    _subscriptionsProvider.addSubscription(_subscriptionDetailsEdit.createData!).then((value){
      if (_state != CreateState.disposed) {
        if (value.error == null) {
          _subscriptionStateProvider.setRefresh(true);
          setState(() {
            _state = CreateState.success;
          });
        } else {
          if (value.error!.startsWith("free members")) {
            showDialog(
              context: context, 
              builder: (ctx) => PremiumErrorDialog(value.error!, MediaQuery.of(context).viewPadding.top)
            );
          } else {
            showDialog(
              context: context, 
              builder: (ctx) => ErrorDialog(value.error!)
            );
          }
          setState(() {
            _state = CreateState.editing;
          });
        } 
      }
    });
  }

  @override
  void dispose() {
    _state = CreateState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == CreateState.init) {
      _subscriptionsProvider = Provider.of<SubscriptionsProvider>(context, listen: false);
      _subscriptionStateProvider = Provider.of<SubscriptionStateProvider>(context, listen: false);
      _subscriptionDetailsEdit = SubscriptionDetailsEdit(null);
    }
    _state = CreateState.editing;
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
        child: _body(),
      ),
    );
  }

  Widget _body() {
    switch (_state) {
      case CreateState.success:
        return Container(
          color: Colors.black54, 
          child: const SuccessView("created", shouldJustPop: true)
        );
      case CreateState.editing:
        return SingleChildScrollView(
          child: _subscriptionDetailsEdit,
        );
      case CreateState.loading:
        return const LoadingView("Creating Subscription");
      default:
        return const LoadingView("Loading");
    }
  }
}