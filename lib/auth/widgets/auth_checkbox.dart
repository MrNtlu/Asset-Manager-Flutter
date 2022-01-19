import 'package:flutter/material.dart';

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
    return GestureDetector(
      onTap: () {
        setState(() {
          setState(() {
            widget._value = !widget._value;
          });
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, 
        children: [
          Checkbox(
            value: widget._value,
            onChanged: (value) {},
          ),
          Text(
            widget.title,
            style: TextStyle(fontSize: 14, color: widget._value ? Colors.black : Colors.grey),
          ),
        ]
      ),
    );
  }
}
