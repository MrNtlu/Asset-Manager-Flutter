import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController? passwordController;
  final String label;
  final TextInputAction textInputAction;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final Icon? prefixIcon;

  const PasswordTextField(
      {this.passwordController,
      this.label = 'Password',
      this.onSaved,
      this.validator,
      this.prefixIcon,
      this.textInputAction = TextInputAction.next});

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
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
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
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
