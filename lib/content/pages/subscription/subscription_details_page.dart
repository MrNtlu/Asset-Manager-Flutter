import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/content/providers/subscription.dart';
import 'package:asset_flutter/content/providers/subscriptions.dart';
import 'package:asset_flutter/content/widgets/portfolio/sd_edit.dart';
import 'package:asset_flutter/content/widgets/portfolio/sd_view.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionDetailsPage extends StatefulWidget {
  late final Subscription _data;
  final String _subscriptionID;

  SubscriptionDetailsPage(
    this._subscriptionID, {Key? key}
  ): super(key: key);

  @override
  State<SubscriptionDetailsPage> createState() => _SubscriptionDetailsPageState();
}

class _SubscriptionDetailsPageState extends State<SubscriptionDetailsPage> {
  bool _isEditing = false;
  bool _isLoading = false;
  bool _isInit = true;
  late final SubscriptionDetailsEdit _updateView;

  void _setUpdateData(){
    if (widget._data.billDate.compareTo(_updateView.datePicker.billDate) != 0) {
      _updateView.updateData!.billDate = _updateView.datePicker.billDate;
    }
    if (widget._data.billCycle != _updateView.billCyclePicker.billCycle) {
      _updateView.updateData!.billCycle = _updateView.billCyclePicker.billCycle;
    }
    if (widget._data.color != _updateView.colorPicker.selectedColor.value) {
      _updateView.updateData!.color = _updateView.colorPicker.selectedColor.value;
    }
  }

  void _updateSubscription(BuildContext context){
    final isValid = _updateView.form.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    _updateView.form.currentState?.save();
    _setUpdateData();

    widget._data.updateSubscription(_updateView.updateData!).then((value){
      setState(() {
        _isLoading = false;
      });
      if (value.error == null) {
        setState(() {
          _isEditing = false;
          _isLoading = false;
        });
      }else {
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
    if(_isInit){
      widget._data = Provider.of<Subscriptions>(context, listen: false).findById(widget._subscriptionID);
      _updateView = SubscriptionDetailsEdit(widget._data);
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {    
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
                  onPressed: () => _updateSubscription(context),
                )
        ],
      ),
      body: SafeArea(
        child: _isLoading ?
        const LoadingView("Updating Subscription...")
        :
        SingleChildScrollView(
          child: !_isEditing ? 
          SubscriptionDetailsView(widget._data)
          :
          _updateView
        ),
      ),
    );
  }
}
