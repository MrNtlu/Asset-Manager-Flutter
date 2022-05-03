import 'dart:io';

import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AuthCheckbox extends StatefulWidget {
  final String title;
  bool _value = false;
  bool getValue() => _value;

  AuthCheckbox(this.title);

  @override
  _AuthCheckboxState createState() => _AuthCheckboxState();
}

class _AuthCheckboxState extends State<AuthCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, 
      children: [
        Platform.isIOS || Platform.isMacOS
        ? Padding(
          padding: const EdgeInsets.only(right: 4),
          child: CupertinoSwitch(
            activeColor: Colors.white,
            thumbColor: widget._value ? AppColors().primaryDarkestColor : Colors.grey.shade300,
            value: widget._value,
            onChanged: (value) {
              setState(() {
                widget._value = !widget._value;
              });
            },
          ),
        )
        : Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: Colors.grey.shade400,
          ),
          child: Checkbox(
            activeColor: Colors.white,
            checkColor: Colors.black,
            value: widget._value,
            onChanged: (value) {
              setState(() {
                widget._value = !widget._value;
              });
            },
          ),
        ),
        Text(
          widget.title,
          style: TextStyle(fontSize: 14, color: widget._value ? Colors.white : Colors.grey.shade400),
        ),
      ]
    );
  }
}
