import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Dropdown extends StatefulWidget {
  final List<String> _dropdownList;
  final TextStyle textStyle;
  final Color dropdownColor;
  final bool isExpanded;

  late String dropdownValue;

  Dropdown(this._dropdownList,
      {this.textStyle = const TextStyle(color: Colors.black),
      this.dropdownColor = Colors.white,
      dropdownValue,
      this.isExpanded = false,
      Key? key})
      : super(key: key) {
    if (dropdownValue == null) {
      this.dropdownValue = _dropdownList[0];
    } else {
      this.dropdownValue = dropdownValue;
    }
  }

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: widget.isExpanded,
        value: widget.dropdownValue,
        style: widget.textStyle,
        dropdownColor: widget.dropdownColor,
        items: widget._dropdownList.map((value) {
          return DropdownMenuItem(
            value: value,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(value),
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              widget.dropdownValue = value;
            });
          }
        },
      ),
    );
  }
}
