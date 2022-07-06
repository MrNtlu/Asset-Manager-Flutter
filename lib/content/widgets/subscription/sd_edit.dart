import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/textformfield.dart';
import 'package:asset_flutter/content/models/requests/subscription.dart';
import 'package:asset_flutter/content/models/responses/subscription.dart';
import 'package:asset_flutter/content/providers/subscription/card.dart';
import 'package:asset_flutter/content/providers/subscription/card_sheet_state.dart';
import 'package:asset_flutter/content/providers/subscription/cards.dart';
import 'package:asset_flutter/content/providers/subscription/subscription.dart';
import 'package:asset_flutter/content/providers/subscription/subscription_image_selection.dart';
import 'package:asset_flutter/content/widgets/subscription/card_sheet.dart';
import 'package:asset_flutter/content/widgets/subscription/sc_image_sheet.dart';
import 'package:asset_flutter/content/widgets/subscription/sd_edit_bill_cycle.dart';
import 'package:asset_flutter/content/widgets/subscription/sd_edit_color_picker.dart';
import 'package:asset_flutter/content/widgets/subscription/sd_edit_date_picker.dart';
import 'package:asset_flutter/content/widgets/subscription/sd_edit_header.dart';
import 'package:asset_flutter/content/widgets/subscription/subscription_image.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/purchase_api.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SubscriptionDetailsEdit extends StatefulWidget {
  final Subscription? _data;
  late final bool isEditing;

  final form = GlobalKey<FormState>();
  final advancedForm = GlobalKey<FormState>();
  late final SubscriptionUpdate? updateData;
  late final SubscriptionCreate? createData;

  late final SDEditDatePicker datePicker;
  late final SDEditBillCycle billCyclePicker;
  late final SDEditColorPicker colorPicker;
  String? selectedDomain;
  CreditCard? selectedCard;

  SubscriptionDetailsEdit(this._data, {Key? key}) : super(key: key) {
    isEditing = _data != null;
    colorPicker = SDEditColorPicker(
      color: _data != null ? Color(_data!.color) : null,
    );
    datePicker = SDEditDatePicker(billDate: _data?.billDate ?? DateTime.now());
    billCyclePicker = SDEditBillCycle(billCycle: _data?.billCycle.copyWith() ?? BillCycle(month: 1));
    selectedCard = (_data != null && _data!.cardID != null) ? CreditCard(_data!.cardID!, '', '', '', '', '', '') :  null;

    if (isEditing) {
      updateData = SubscriptionUpdate(_data!.id);
    } else {
      createData = SubscriptionCreate('', BillCycle(), DateTime.now(), 0.0, '',  '', 0);
    }
  }

  @override
  State<SubscriptionDetailsEdit> createState() => _SubscriptionDetailsEditState();
}

class _SubscriptionDetailsEditState extends State<SubscriptionDetailsEdit> {
  EditState _state = EditState.init;
  late final SubscriptionImageSelection _imageSelection;
  bool isInit = false;

  @override
  void dispose() {
    _imageSelection.onDispose();
    _state = EditState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == EditState.init) {
      _imageSelection = Provider.of<SubscriptionImageSelection>(context, listen: false);
      if (widget.isEditing && widget.selectedCard != null) {
        widget.selectedCard = Provider.of<CardProvider>(context).findById(widget.selectedCard!.id);
      }
      _state = EditState.view;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<SubscriptionImageSelection>(builder: (context, selection, _) {
          widget.selectedDomain = selection.selectedImage;

          return widget.selectedDomain == null && !widget.isEditing
          ? Padding(
            padding: const EdgeInsets.all(8),
            child: TextButton(
              onPressed: () => showModalBottomSheet(
                context: context, 
                enableDrag: false,
                shape: Platform.isIOS || Platform.isMacOS
                ? const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    topLeft: Radius.circular(16)
                  ),
                )
                : null,
                builder: (_) => const SubscriptionCreateImageSheet()
              ),
              child: const Text(
                "Select Subscription Image",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          )
          : Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SubscriptionImage(
                  widget.isEditing && widget.selectedDomain == null
                  ? widget._data!.image
                  : widget.selectedDomain!, 
                  Colors.black,
                  size: 52,
                ),
                TextButton(
                  onPressed: () => showModalBottomSheet(
                    context: context, 
                    enableDrag: false,
                    shape: Platform.isIOS || Platform.isMacOS
                    ? const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        topLeft: Radius.circular(16)
                      ),
                    )
                    : null,
                    builder: (_) => const SubscriptionCreateImageSheet()
                  ), 
                  child: const Text(
                    "Change",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  )
                )
              ],
            ),
          );
        }),
        Form(
          key: widget.form,
          child: widget.isEditing ? 
          SDEditHeader(
            name: widget._data!.name,
            price: widget._data!.price,
            description: widget._data!.description,
            currency: widget._data!.currency,
            updateData: widget.updateData,
            isEditing: true,
          )
          : 
          SDEditHeader(
            createData: widget.createData,
            currency: PurchaseApi().userInfo?.currency ?? "USD",
          )
        ),
        widget.datePicker,
        const Divider(thickness: 1),
        _subSectionTitle("Bill Cycle"),
        widget.billCyclePicker,
        const Divider(thickness: 1),
        _subSectionTitle("Pick Color"),
        Container(
          margin: const EdgeInsets.fromLTRB(12, 8, 8, 4),
          child: widget.colorPicker
        ),
        const Divider(thickness: 1),
        _subSectionTitle("Credit Card (Optional)"),
        Container(
          margin: const EdgeInsets.fromLTRB(12, 8, 8, 4),
          child: Consumer<CardSheetSelectionStateProvider>(builder: (context, selection, _) {
            if (isInit) {
              widget.selectedCard = selection.selectedCard;
            } else {
              isInit = true;
            }
            return TextButton(
              child: Text(
                widget.selectedCard != null
                ? "${widget.selectedCard!.name} ${widget.selectedCard!.lastDigits}"
                : "No Card Selected",
                style: const TextStyle(fontSize: 16),
              ),
              onPressed: () => showModalBottomSheet(
                context: context,
                shape: Platform.isIOS || Platform.isMacOS
                ? const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    topLeft: Radius.circular(16)
                  ),
                )
                : null,
                enableDrag: false,
                isDismissible: true,
                builder: (_) => CardSelectionSheet(widget.selectedCard)
              ),
            );
          }),
        ),
        const Divider(thickness: 1),
        Row(
          children: [
            Expanded(child: _subSectionTitle("Notification Reminder")),
            Lottie.asset(
              "assets/lottie/premium.json",
              height: 32,
              width: 32,
              frameRate: FrameRate(60)
            ),
          ],
        ),
        // TODO Add overlay that prevents nonpremium users to interact
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(
                Icons.notification_add_rounded,
                size: 32,                    
              ),
              Expanded(
                child: Text(
                  DateTime.now().dateToTime(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Platform.isIOS || Platform.isMacOS
              ? Padding(
                padding: const EdgeInsets.only(right: 4),
                child: CupertinoSwitch(
                  activeColor: Theme.of(context).colorScheme.bgTextColor,
                  trackColor: Theme.of(context).colorScheme.bgTransparentColor,
                  thumbColor: false ? Theme.of(context).colorScheme.bgColor : Theme.of(context).colorScheme.bgTextColor,
                  value: false,
                  onChanged: (value) {
                    setState(() {
                      // widget._value = !widget._value;
                    });
                  },
                ),
              )
              : Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: Colors.grey.shade400,
                ),
                child: Checkbox(
                  activeColor: Theme.of(context).colorScheme.bgTextColor,
                  checkColor: Theme.of(context).colorScheme.bgColor,
                  value: false,
                  onChanged: (value) {
                    setState(() {
                      // widget._value = !widget._value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        const Divider(thickness: 1),
        _subSectionTitle("Advanced Options (Optional)"),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 12, top: 8, bottom: 4),
          child: Text(
            "You can enter your subscription account. Password will be encrypted.", 
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Theme.of(context).colorScheme.bgTransparentColor,
              fontSize: 12
            ),
          )
        ),
        Form(
          key: widget.advancedForm,
          child: Column(
            children: [
              CustomTextFormField(
                "Username/Email",
                TextInputType.emailAddress,
                initialText: "",
                edgeInsets: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
                textInputAction: TextInputAction.next,
                onSaved: (value) {
                  // if (value != null) {
                  //   if(widget.isEditing && widget.name != value){
                  //     widget.updateData!.name = value;
                  //   } else if (!widget.isEditing) {
                  //     widget.createData!.name = value;
                  //   }
                  // }
                },
              ),
              CustomTextFormField(
                "Password",
                TextInputType.visiblePassword,
                initialText: "",
                edgeInsets: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
                textInputAction: TextInputAction.done,
                onSaved: (value) {
                  // if (value != null) {
                  //   if(widget.isEditing && widget.name != value){
                  //     widget.updateData!.name = value;
                  //   } else if (!widget.isEditing) {
                  //     widget.createData!.name = value;
                  //   }
                  // }
                },
              ),
              const Divider(thickness: 1)
            ],
          ),
        ),
      ],
    );
  }

  Widget _subSectionTitle(String title) => Container(
    margin: const EdgeInsets.fromLTRB(12, 8, 8, 4),
    alignment: Alignment.centerLeft,
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 16, 
        fontWeight: FontWeight.bold
      ),
    ),
  );
}
