import 'dart:io';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

// ignore_for_file: must_be_immutable
class TransactionCreateDateTimePicker extends StatefulWidget {
  DateTime selectedDateTime;

  TransactionCreateDateTimePicker(this.selectedDateTime, {Key? key}) : super(key: key);

  @override
  State<TransactionCreateDateTimePicker> createState() => _TransactionCreateDateTimePickerState();
}

class _TransactionCreateDateTimePickerState extends State<TransactionCreateDateTimePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            widget.selectedDateTime.dateToFullDateTime(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Platform.isIOS || Platform.isMacOS 
          ? CupertinoButton(
            padding: const EdgeInsets.all(12),
            onPressed: () => _showDateTimePicker(), 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.more_time_rounded, size: 20),
                ),
                Text("Pick Date", style: TextStyle(fontSize: 16))
              ],
            ),
          )
          : TextButton.icon(
            onPressed: () => _showDateTimePicker(), 
            label: const Text("Pick Date", style: TextStyle(fontSize: 16)),
            icon: const Icon(Icons.more_time_rounded, size: 20)
          ),
        )
      ],
    );
  }

  void _showDateTimePicker() {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2021, 5, 1),
      maxTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 7),
      onConfirm: (date) {
        setState(() {
          widget.selectedDateTime = date;
        });
      }, 
      currentTime: widget.selectedDateTime, 
      locale: LocaleType.en
    );
  }
}