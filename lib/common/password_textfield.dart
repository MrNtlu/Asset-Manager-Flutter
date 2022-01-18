import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController passwordController;

  const PasswordTextField(this.passwordController);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(32, 16, 32, 0),
      child: TextField(
        controller: widget.passwordController,
        obscureText: _isHidden,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
          labelText: 'Password',
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
