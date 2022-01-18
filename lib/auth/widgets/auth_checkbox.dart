import 'package:flutter/material.dart';

class AuthCheckbox extends StatefulWidget {
  final String title;

  const AuthCheckbox(this.title);

  @override
  _AuthCheckboxState createState() => _AuthCheckboxState();
}

class _AuthCheckboxState extends State<AuthCheckbox> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: _value, 
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _value = value;
              });
            }
          },
        ),
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 14,
            color: _value ? Colors.black : Colors.grey
          ),
        )
      ]
    );
  }
}
