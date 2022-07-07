import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/success_view.dart';
import 'package:asset_flutter/content/providers/subscription/subscription.dart';
import 'package:asset_flutter/content/providers/subscription/subscription_state.dart';
import 'package:asset_flutter/content/providers/subscription/subscriptions.dart';
import 'package:asset_flutter/content/widgets/subscription/sd_edit.dart';
import 'package:asset_flutter/content/widgets/subscription/sd_view.dart';
import 'package:asset_flutter/content/widgets/subscription/subscription_image.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionDetailsPage extends StatefulWidget {
  final String _subscriptionID;
  final bool isCardDetails;

  const SubscriptionDetailsPage(
    this._subscriptionID, {
      this.isCardDetails = false,
      Key? key
    }
  ): super(key: key);

  @override
  State<SubscriptionDetailsPage> createState() => _SubscriptionDetailsPageState();
}

class _SubscriptionDetailsPageState extends State<SubscriptionDetailsPage> {
  EditState _state = EditState.init;
  late final Subscription _data;
  late final SubscriptionDetailsEdit _updateView;
  late final SubscriptionDetailsView _detailsView;
  late final SubscriptionStateProvider _subscriptionStateProvider;

  void _setUpdateData(){
    if (_data.billDate.compareTo(_updateView.datePicker.billDate) != 0) {
      _updateView.updateData!.billDate = _updateView.datePicker.billDate;
    }

    if (_data.billCycle != _updateView.billCyclePicker.billCycle) {
      _updateView.updateData!.billCycle = _updateView.billCyclePicker.billCycle;
    }
    if (_data.color != _updateView.colorPicker.selectedColor.value) {
      _updateView.updateData!.color = _updateView.colorPicker.selectedColor.value;
    }

    if (_data.image != _updateView.selectedDomain) {
      _updateView.updateData!.image = _updateView.selectedDomain;
    }

    _updateView.updateData!.notificationTime = _updateView.notificationSwitch.selectedDate; 

    _updateView.updateData!.cardID = _updateView.selectedCard?.id;
  }

  void _updateSubscription(BuildContext context){
    final isValid = _updateView.form.currentState?.validate();
    final isAdvancedValid = _updateView.advancedForm.currentState?.validate();
    if (
      (isValid != null && !isValid) ||
      (isAdvancedValid != null && !isAdvancedValid)
    ) {
      return;
    }
    setState(() {
      _state = EditState.loading;
    });

    _updateView.form.currentState?.save();
    _updateView.advancedForm.currentState?.save();
    _setUpdateData();

    _data.updateSubscription(_updateView.updateData!).then((value) {
      if (_state != EditState.disposed) {
        if (value.error == null) {
          _subscriptionStateProvider.setRefresh(true);
          setState(() {
            _state = EditState.view;
          });
          showDialog(
            barrierColor: Colors.black54,
            context: context, 
            builder: (ctx) => const SuccessView("updated", shouldJustPop: true)
          );
        } else {
          showDialog(context: context, builder: (ctx) => ErrorDialog(value.error!));
          setState(() {
            _state = EditState.editing;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _state = EditState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if(_state == EditState.init){
      _data = Provider.of<SubscriptionsProvider>(context, listen: false).findById(widget._subscriptionID);
      _subscriptionStateProvider = Provider.of<SubscriptionStateProvider>(context, listen: false);
      _updateView = SubscriptionDetailsEdit(_data);
      _detailsView = SubscriptionDetailsView(_data, isCardDetails: widget.isCardDetails);
      _state = EditState.view;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: _state == EditState.editing ? Theme.of(context).colorScheme.bgTextColor : Colors.white,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_state != EditState.editing)
            SubscriptionImage(_data.image, Color(_data.color)),
            Text(
              _state == EditState.editing ? "Edit" : _data.name, 
              style: TextStyle(
                color: _state == EditState.editing ? Theme.of(context).colorScheme.bgTextColor : Colors.white,
                fontWeight: _state == EditState.editing ? FontWeight.normal : FontWeight.bold
              )
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: _state == EditState.editing ? Theme.of(context).colorScheme.bgColor : Color(_data.color),
        actions: widget.isCardDetails ? null : _iconButtons(),
      ),
      body: SafeArea(
        child: _body()
      ),
    );
  }

  List<Widget> _iconButtons() {
    if (_state == EditState.editing) {
      return [
        IconButton(
          onPressed: () => setState(() {
            _state = EditState.view;
          }),
          icon: const Icon(Icons.cancel_rounded),
          tooltip: 'Discard Changes',
        ),
        IconButton(
          icon: const Icon(Icons.save_rounded),
          tooltip: 'Save Changes',
          onPressed: () => _updateSubscription(context),
        )
      ];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.edit_rounded),
          tooltip: 'Enter Edit State',
          onPressed: () {
            if (_detailsView.canEnterEditMode) {
              setState(() {
                _state = EditState.editing;
              });
            }
          },
        )
      ];
    }
  }

  Widget _body() {
    switch (_state) {
      case EditState.editing:
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(child: _updateView),
        );
      case EditState.view:
        return SingleChildScrollView(child: _detailsView);
      case EditState.loading:
        return const LoadingView("Updating Subscription");
      default:
        return const LoadingView("Loading");
    }
  }
}
