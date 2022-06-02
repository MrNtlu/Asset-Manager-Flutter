import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String _label;
  final TextInputType _keyboardType;
  final TextEditingController? textfieldController;
  final Icon? prefixIcon;
  final TextInputAction textInputAction;
  final String? initialText;
  final EdgeInsets? edgeInsets;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final InputBorder? defaultBorder;
  final TextStyle? errorTextStyle;

  final Function(String?)? onSaved;
  final String? Function(String?)? validator;

  const CustomTextFormField(this._label, this._keyboardType,
      {this.textfieldController,
      this.prefixIcon,
      this.textInputAction = TextInputAction.next,
      this.initialText,
      this.edgeInsets = const EdgeInsets.fromLTRB(32, 16, 32, 0),
      this.onSaved,
      this.validator,
      this.focusedBorder = const OutlineInputBorder(borderSide: BorderSide(width: 0)),
      this.enabledBorder = const OutlineInputBorder(borderSide: BorderSide(width: 0)),
      this.defaultBorder = const OutlineInputBorder(borderSide: BorderSide(width: 0)),
      this.errorTextStyle,
    }
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: edgeInsets,
      child: TextFormField(
        keyboardType: _keyboardType,
        controller: textfieldController,
        textInputAction: textInputAction,
        onSaved: onSaved,
        validator: validator,
        initialValue: initialText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          errorStyle: errorTextStyle,
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
          border: defaultBorder,
          labelText: _label,
          prefixIcon: prefixIcon
        ),
      )
    );
  }
}
