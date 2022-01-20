import 'dart:io';

import 'package:asset_flutter/auth/pages/register_page.dart';
import 'package:asset_flutter/auth/widgets/auth_bottom_sheet.dart';
import 'package:asset_flutter/common/widgets/expanded_divider.dart';
import 'package:flutter/material.dart';
import 'package:asset_flutter/common/widgets/textfield.dart';
import 'package:asset_flutter/common/widgets/password_textfield.dart';
import 'package:asset_flutter/auth/widgets/auth_button.dart';
import 'package:asset_flutter/auth/widgets/auth_checkbox.dart';

class LoginPage extends StatelessWidget {
  static const routeName = "/login";

  String? userID;

  final emailInput = TextEditingController();
  final passwordInput = TextEditingController();
  AuthCheckbox? checkbox;

  void onSigninPressed(BuildContext ctx) {
    print("EmailInput: " +
        emailInput.text +
        " Password: " +
        passwordInput.text +
        " " +
        (checkbox != null ? checkbox!.getValue().toString() : "null"));

    // Navigator.of(ctx).push(
    //   MaterialPageRoute(builder: (_){
    //     return LoginPage(userID);
    //   })
    // );
  }

  void onRegisterPressed(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(RegisterPage.routeName);
  }

  void openForgotPasswordBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return AuthBottomSheet();
        });
  }

  @override
  Widget build(BuildContext context) {
    final AppBar appBar = AppBar(
      title: const Text('Login'),
    );

    checkbox = AuthCheckbox('Remember Password');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: CustomScrollView(
        physics: const ScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            fillOverscroll: false,
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                      margin: const EdgeInsets.all(32),
                      child: const FlutterLogo(size: 128)),
                  CustomTextField(
                    'Email',
                    TextInputType.emailAddress,
                    textfieldController: emailInput,
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Color(0xFF00579B),
                    ),
                  ),
                  PasswordTextField(
                    passwordInput,
                    prefixIcon: const Icon(
                      Icons.password,
                      color: Color(0xFF00579B),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          left: (Platform.isMacOS || Platform.isWindows)
                              ? 26
                              : 18,
                          top:
                              (Platform.isMacOS || Platform.isWindows) ? 8 : 4),
                      child: checkbox),
                  AuthButton(
                      onSigninPressed, 'Sign In', const Color(0xFF54C4F8)),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: const [
                        ExpandedDivider(10, 20, 24),
                        Text("OR"),
                        ExpandedDivider(20, 10, 24),
                      ],
                    ),
                  ),
                  AuthButton(
                      onRegisterPressed, 'Register', const Color(0xFF00579B)),
                  Expanded(
                    child: Container(
                      margin:
                          const EdgeInsetsDirectional.only(bottom: 32, end: 32),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                            onPressed: () =>
                                openForgotPasswordBottomSheet(context),
                            child: const Text('Forgot Password')),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
