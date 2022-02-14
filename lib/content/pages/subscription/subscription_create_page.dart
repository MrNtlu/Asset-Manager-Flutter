import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/content/providers/subscriptions.dart';
import 'package:asset_flutter/content/widgets/portfolio/sd_edit.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionCreatePage extends StatefulWidget {
  late final SubscriptionDetailsEdit _subscriptionDetailsEdit;
  late final Subscriptions _subscriptionsProvider;

  @override
  State<SubscriptionCreatePage> createState() => _SubscriptionCreatePageState();
}

class _SubscriptionCreatePageState extends State<SubscriptionCreatePage> {
  bool _isInit = false;
  bool _isLoading = false;

  void _setCreateData(){
    widget._subscriptionDetailsEdit.createData!.billDate = widget._subscriptionDetailsEdit.datePicker.billDate;
    widget._subscriptionDetailsEdit.createData!.billCycle = widget._subscriptionDetailsEdit.billCyclePicker.billCycle;
    widget._subscriptionDetailsEdit.createData!.color = widget._subscriptionDetailsEdit.colorPicker.selectedColor.value;
  }

  void _createSubscription(BuildContext context) {
    final isValid = widget._subscriptionDetailsEdit.form.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    widget._subscriptionDetailsEdit.form.currentState?.save();
    _setCreateData();

    widget._subscriptionsProvider.addSubscription(widget._subscriptionDetailsEdit.createData!).then((value){
      setState(() {
        _isLoading = false;
      });
      if (value.error == null) {
        Navigator.pop(context);
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
    super.didChangeDependencies();
    if (!_isInit) {
      widget._subscriptionsProvider = Provider.of<Subscriptions>(context, listen: false);
      widget._subscriptionDetailsEdit = SubscriptionDetailsEdit(null);
      _isInit = true;
    }
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
            onPressed: () => _createSubscription(context),
          )
        ],
      ),
      body: SafeArea(
        child: _isLoading ? 
        const LoadingView("Creating Subscription...")
        : 
        SingleChildScrollView(
          child: widget._subscriptionDetailsEdit,
        ),
      ),
    );
  }
}