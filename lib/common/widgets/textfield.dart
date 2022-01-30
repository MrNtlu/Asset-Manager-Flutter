import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String _label;
  final TextInputType _keyboardType;
  final TextEditingController? textfieldController;
  final Icon? prefixIcon;

  const CustomTextField(this._label, this._keyboardType, {this.textfieldController, this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(32, 16, 32, 0),
        child: TextField(
          keyboardType: _keyboardType,
          controller: textfieldController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(),
            labelText: _label,
            prefixIcon: prefixIcon
          ),
        ));
  }
}
