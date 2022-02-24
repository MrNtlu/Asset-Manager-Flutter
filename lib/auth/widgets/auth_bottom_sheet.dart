import 'dart:convert';

import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/success_view.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:flutter/material.dart';
import 'auth_button.dart';
import 'package:asset_flutter/common/widgets/textformfield.dart';
import 'package:http/http.dart' as http;

class AuthBottomSheet extends StatelessWidget {
  final _emailInput = TextEditingController();

  void onSendEmailPressed(BuildContext context) {
    Navigator.pop(context);
    try {
      http.post(
        Uri.parse(APIRoutes().userRoutes.forgotPassword),
        body: json.encode({
          "email_address": _emailInput.text,
        }),
      );

      showDialog(
        context: context, 
        builder: (ctx) => const SuccessView("sent email", shouldJustPop: true)
      );
    } catch(error) {
      showDialog(
        context: context, 
        builder: (ctx) => ErrorDialog(error.toString())
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      margin: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomTextFormField(
            'Email', 
            TextInputType.emailAddress, 
            textfieldController: _emailInput,
            prefixIcon: Icon(
              Icons.email,
              color: AppColors().primaryColor
            ),
            textInputAction: TextInputAction.done,
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(32, 8, 32, 16),
            child: const Text(
              "Please enter your email address. You'll receive password recet email if you have an account.",
              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
              ),
            )
          ),
          AuthButton(onSendEmailPressed, 'Reset', AppColors().lightBlack)
        ],
      ),
    ); 
  }
}
