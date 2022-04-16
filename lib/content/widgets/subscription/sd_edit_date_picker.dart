import 'dart:io';

import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SDEditDatePicker extends StatefulWidget {
  DateTime billDate;
  SDEditDatePicker({required this.billDate, Key? key}) : super(key: key);

  @override
  State<SDEditDatePicker> createState() => SDEditDatePickerState();
}

class SDEditDatePickerState extends State<SDEditDatePicker> {
  @override
  Widget build(BuildContext context) {
    final bool isApple = Platform.isIOS || Platform.isMacOS;

    return Container(
      margin: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              widget.billDate.dateToFormatDate(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: isApple 
            ? CupertinoButton.filled(
              padding: const EdgeInsets.all(12),
              onPressed: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: widget.billDate,
                  firstDate: DateTime(2015),
                  lastDate: DateTime(DateTime.now().year + 3)
                );
                if(selectedDate != null) {
                  setState(() {
                    widget.billDate = selectedDate;
                  });
                }
                return;
              }, 
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
            : ElevatedButton.icon(
              onPressed: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: widget.billDate,
                  firstDate: DateTime(2015),
                  lastDate: DateTime(DateTime.now().year + 3)
                );
                if(selectedDate != null) {
                  setState(() {
                    widget.billDate = selectedDate;
                  });
                }
                return;
              }, 
              label: const Text("Pick Date", style: TextStyle(fontSize: 16)),
              icon: const Icon(Icons.more_time_rounded, size: 20)
            ),
          )
        ],
      ),
    );
  }
}