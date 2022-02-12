import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  final List<String> _dropdownList;
  final TextStyle textStyle;
  final Color dropdownColor;

  late String dropdownValue;

  Dropdown(this._dropdownList,
      {this.textStyle = const TextStyle(color: Colors.black),
      this.dropdownColor = Colors.white,
      this.dropdownValue = "USD",
      Key? key})
      : super(key: key);

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
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
