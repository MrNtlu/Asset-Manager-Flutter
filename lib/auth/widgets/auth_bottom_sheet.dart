import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';
import 'auth_button.dart';
import 'package:asset_flutter/common/widgets/textformfield.dart';

class AuthBottomSheet extends StatelessWidget {
  final _emailInput = TextEditingController();

  void onSendEmailPressed(BuildContext ctx) {
    //TODO: Implement
    Navigator.of(ctx).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      margin: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          CustomTextFormField(
            'Email', 
            TextInputType.emailAddress, 
            textfieldController: null,
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
