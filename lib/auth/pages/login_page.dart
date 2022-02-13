import 'dart:io';

import 'package:asset_flutter/auth/models/requests/user.dart';
import 'package:asset_flutter/auth/pages/register_page.dart';
import 'package:asset_flutter/auth/widgets/auth_bottom_sheet.dart';
import 'package:asset_flutter/common/widgets/expanded_divider.dart';
import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:asset_flutter/common/widgets/textformfield.dart';
import 'package:asset_flutter/common/widgets/password_textformfield.dart';
import 'package:asset_flutter/auth/widgets/auth_button.dart';
import 'package:asset_flutter/auth/widgets/auth_checkbox.dart';

class LoginPage extends StatelessWidget {
  static const routeName = "/login";
  late String token;

  AuthCheckbox? checkbox;
  final _form = GlobalKey<FormState>();
  final _loginModel = Login('', '');

  void onSigninPressed(BuildContext ctx) {
    /* TODO:
    if >>> no sharedpref saved
      Send login request
      if >>> no error
        Check if remember password checked.
        If >>> checked 
          save password
        login, save token & redirect
      else >>>
        show error dialog
    else >>>
      try to login via savedpref
      if >>> no error
        line 32
      else >>>
        line 32
    */

    final isValid = _form.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }
    _form.currentState?.save();
    token = _loginModel.emailAddress;


    Navigator.of(ctx).pushReplacement(MaterialPageRoute(builder: (_) {
      return TabsPage(token);
    }));
  }

  void onRegisterPressed(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(RegisterPage.routeName);
  }

  void openForgotPasswordBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return AuthBottomSheet();
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppBar appBar = AppBar(
      title: const Text('Login'),
      backgroundColor: AppColors().primaryColor,
    );

    checkbox = AuthCheckbox('Remember Password');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: SafeArea(
        child: CustomScrollView(
          physics: const ScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              fillOverscroll: false,
              child: Center(
                child: Form(
                  key: _form,
                  child: Column(
                    children: <Widget>[
                      Container(
                          margin: const EdgeInsets.all(32),
                          child: const FlutterLogo(size: 128)),
                      CustomTextFormField(
                        'Email',
                        TextInputType.emailAddress,
                        prefixIcon: Icon(
                          Icons.email,
                          color: AppColors().primaryColor,
                        ),
                        onSaved: (value){
                          if (value != null) {
                            _loginModel.emailAddress = value;
                          }
                        },
                        validator: (value) {
                          if (value != null) {
                            if (value.isEmpty) {
                              return "Please don't leave this empty.";
                            } else if (!value.isEmailValid()) {
                              return "Email is not valid.";
                            }
                          }

                          return null;
                        },
                      ),
                      PasswordTextField(
                        prefixIcon: Icon(
                          Icons.password,
                          color: AppColors().primaryColor,
                        ),
                        textInputAction: TextInputAction.done,
                        onSaved: (value){
                          if (value != null) {
                            _loginModel.password = value;
                          }
                        },
                        validator: (value) {
                          if (value != null) {
                            if (value.isEmpty) {
                              return "Please don't leave this empty.";
                            }
                          }

                          return null;
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: (Platform.isMacOS || Platform.isWindows) ? 26 : 18,
                            top: (Platform.isMacOS || Platform.isWindows) ? 8 : 4),
                        child: checkbox
                      ),
                      AuthButton(
                          onSigninPressed, 'Sign In', AppColors().primaryLightColor),
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
                          onRegisterPressed, 'Register', AppColors().primaryColor),
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
            ),
          ],
        ),
      ),
    );
  }
}
