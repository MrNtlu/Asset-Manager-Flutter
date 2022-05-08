import 'package:flutter/material.dart';

class PasswordTextFormField extends StatefulWidget {
  final TextEditingController? passwordController;
  final String label;
  final TextInputAction textInputAction;
  final String? initialText;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final Icon? prefixIcon;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final InputBorder? defaultBorder;
  final TextStyle? errorTextStyle;

  const PasswordTextFormField(
    {
      this.passwordController,
      this.label = 'Password',
      this.onSaved,
      this.validator,
      this.prefixIcon,
      this.initialText,
      this.textInputAction = TextInputAction.next,
      this.focusedBorder = const OutlineInputBorder(),
      this.enabledBorder = const OutlineInputBorder(),
      this.defaultBorder = const OutlineInputBorder(),
      this.errorTextStyle,
    }
  );

  @override
  _PasswordTextFormFieldState createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool _isHidden = true;

  @override
  void dispose() {
    widget.passwordController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(32, 16, 32, 0),
      child: TextFormField(
        controller: widget.passwordController,
        obscureText: _isHidden,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: widget.textInputAction,
        onSaved: widget.onSaved,
        validator: widget.validator,
        initialValue: widget.initialText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          enabledBorder: widget.enabledBorder,
          focusedBorder: widget.focusedBorder,
          errorStyle: widget.errorTextStyle,
          border: widget.defaultBorder,
          labelText: widget.label,
          prefixIcon: widget.prefixIcon,
          suffixIcon: Padding(
            padding: EdgeInsetsDirectional.zero,
            child: GestureDetector(
              child: Icon(
                _isHidden ? Icons.visibility : Icons.visibility_off,
                size: 20.0,
                color: Colors.black,
              ),
              onTap: () {
                setState(() {
                  _isHidden = !_isHidden;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
