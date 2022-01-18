import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  TextEditingController? textfieldController;

  CustomTextField(this.label, this.keyboardType, {this.textfieldController});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(32, 16, 32, 0),
        child: TextField(
          keyboardType: keyboardType,
          controller: textfieldController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(),
            labelText: label,
          ),
        ));
  }
}
