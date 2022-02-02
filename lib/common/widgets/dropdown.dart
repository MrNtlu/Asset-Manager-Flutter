import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  final List<String> _dropdownList;

  const Dropdown(this._dropdownList, {Key? key}) : super(key: key);

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  late String dropdownValue;

  @override
  void initState() {
    super.initState();
    dropdownValue = widget._dropdownList[0];
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: dropdownValue,
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
              dropdownValue = value;
            });
          }
          print(value);
        },
      ),
    );
  }
}
