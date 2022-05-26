import 'dart:io';

import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TransactionSheetDateRangePicker extends StatefulWidget {
  DateTimeRange? dateTimeRange;

  TransactionSheetDateRangePicker({Key? key}) : super(key: key);

  @override
  State<TransactionSheetDateRangePicker> createState() => _TransactionSheetDateRangePickerState();
}

class _TransactionSheetDateRangePickerState extends State<TransactionSheetDateRangePicker> {
  @override
  Widget build(BuildContext context) {
    final bool isApple = Platform.isIOS || Platform.isMacOS;

    return isApple
    ? CupertinoButton(
      child: _buttonText(), 
      onPressed: _onButtonPressed
    )
    : TextButton(
      onPressed: _onButtonPressed, 
      child: _buttonText()
    );
  }

  void _onButtonPressed() async {
    final dateTimeRange = await showDateRangePicker(
      context: context, 
      firstDate: DateTime(2021, 5, 1), 
      lastDate: DateTime.now(),
    );

    setState(() {
      widget.dateTimeRange = dateTimeRange;
    });
  }

  Widget _buttonText() => Text(
    widget.dateTimeRange != null 
    ? widget.dateTimeRange!.start.dateToHumanDate() + " - " + widget.dateTimeRange!.end.dateToHumanDate()
    : "Select Date Range",
    style: const TextStyle(
      fontSize: 16
    ),
  );
}