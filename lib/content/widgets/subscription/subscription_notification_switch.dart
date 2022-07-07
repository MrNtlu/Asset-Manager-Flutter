import 'dart:io';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/purchase_api.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SubscriptionNotificationSwitch extends StatefulWidget {
  bool isOn = false;
  DateTime? selectedDate;

  SubscriptionNotificationSwitch({
    this.selectedDate,
    Key? key
  }) : super(key: key){
    isOn = selectedDate != null;
  }

  @override
  State<SubscriptionNotificationSwitch> createState() => _SubscriptionNotificationSwitchState();
}

class _SubscriptionNotificationSwitchState extends State<SubscriptionNotificationSwitch> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                widget.isOn
                ? Icons.notifications_on_rounded
                : Icons.notifications_off_rounded,
                size: 32,                    
              ),
              Expanded(
                child: Text(
                  widget.selectedDate?.toLocal().dateToTime() ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Platform.isIOS || Platform.isMacOS
              ? Padding(
                padding: const EdgeInsets.only(right: 4),
                child: CupertinoSwitch(
                  activeColor: Theme.of(context).colorScheme.bgTextColor,
                  trackColor: Theme.of(context).colorScheme.bgTransparentColor,
                  thumbColor: widget.isOn ? Theme.of(context).colorScheme.bgColor : Theme.of(context).colorScheme.bgTextColor,
                  value: widget.isOn,
                  onChanged: onSwitchChanged,
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
                  onChanged: onSwitchChanged,
                ),
              )
            ],
          ),
        ),
        if (
          PurchaseApi().userInfo != null && !(PurchaseApi().userInfo!.isPremium || PurchaseApi().userInfo!.isLifetimePremium) &&
          widget.selectedDate == null
        )
        Container(
          width: double.infinity,
          height: 60,
          color: Theme.of(context).brightness == Brightness.dark ? Colors.black38: Colors.white38,
          child: const Center(
            child: Text(
              "Premium Required",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: CupertinoColors.activeBlue
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onSwitchChanged(bool? value) async {
    if (value != null) {
      if (value) {
        final selectedTime = await showTimePicker(
          context: context, 
          initialTime: widget.selectedDate != null
          ? TimeOfDay.fromDateTime(widget.selectedDate!)
          : TimeOfDay.now(),
        );

        if (selectedTime != null) {
          final now = DateTime.now();  
          widget.selectedDate = DateTime(now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);
        }
      } else {
        widget.selectedDate = null;
      }

      setState(() {
        widget.isOn = !widget.isOn;
      });
    } 
  }
}