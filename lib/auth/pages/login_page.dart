import 'dart:io';

import 'package:asset_flutter/auth/models/requests/user.dart';
import 'package:asset_flutter/auth/pages/register_page.dart';
import 'package:asset_flutter/auth/widgets/auth_bottom_sheet.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/expanded_divider.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/shared_pref.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:asset_flutter/common/widgets/textformfield.dart';
import 'package:asset_flutter/common/widgets/password_textformfield.dart';
import 'package:asset_flutter/auth/widgets/auth_button.dart';
import 'package:asset_flutter/auth/widgets/auth_checkbox.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "/login";
  final _form = GlobalKey<FormState>();
  final _loginModel = Login('', '');
  late final String token;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _isInit = false;
  late final AuthCheckbox _checkbox;

  void _onSigninPressed(BuildContext ctx, {Login? login}) {
    if (login == null) {
      final isValid = widget._form.currentState?.validate();
      if (isValid != null && !isValid) {
        return;
      }
      widget._form.currentState?.save();
    } 
    setState(() {
      _isLoading = true;
    });

    var _login = login ?? widget._loginModel;
    _login.login().then((value) {
      setState(() {
        _isLoading = false;
      });

      if (value.message != null) {
        showDialog(
          context: context, 
          builder: (ctx) => ErrorDialog(value.message!)
        );

        if (login != null && value.code != null && value.code == 401) {
          SharedPref().deleteLoginCredentials();
        }
      }else {
        widget.token = value.token!;
        if (_checkbox.getValue()) {
          SharedPref().setLoginCredentials(widget._loginModel.emailAddress, widget._loginModel.password);
        }

        Navigator.of(ctx).pushReplacement(MaterialPageRoute(builder: (_) {
          return TabsPage(widget.token);
        }));
      }
    });
  }

  void _openForgotPasswordBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => AuthBottomSheet()
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _checkbox = AuthCheckbox('Remember Password');
      SharedPref().init().then((_) {
        var loginCreds = SharedPref().getLoginCredentials();

        if (loginCreds.keys.first) {
          _onSigninPressed(context, login: loginCreds.values.first);
        }
      });

      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: AppColors().primaryColor,
      ),
      body: SafeArea(
        child: _isLoading
            ? const LoadingView("Please wait while logging in...")
            : CustomScrollView(
                physics: const ScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    fillOverscroll: false,
                    child: Center(
                      child: Form(
                        key: widget._form,
                        child: Column(
                          children: <Widget>[
                            Container(
                                margin: const EdgeInsets.all(32),
                                child: const FlutterLogo(size: 128)),
                            CustomTextFormField(
                              'Email',
                              TextInputType.emailAddress,
                              initialText: widget._loginModel.emailAddress.trim() != '' 
                                ? widget._loginModel.emailAddress 
                                : null,
                              prefixIcon: Icon(
                                Icons.email,
                                color: AppColors().primaryColor,
                              ),
                              onSaved: (value) {
                                if (value != null) {
                                  widget._loginModel.emailAddress = value;
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
                            PasswordTextFormField(
                              initialText: widget._loginModel.password.trim() != '' 
                                ? widget._loginModel.password 
                                : null,
                              prefixIcon: Icon(
                                Icons.password,
                                color: AppColors().primaryColor,
                              ),
                              textInputAction: TextInputAction.done,
                              onSaved: (value) {
                                if (value != null) {
                                  widget._loginModel.password = value;
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
                              child: _checkbox
                            ),
                            AuthButton((BuildContext ctx){
                              _onSigninPressed(context);
                            }, 'Sign In', AppColors().primaryLightColor),
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
                            AuthButton((BuildContext ctx){
                              Navigator.of(ctx).pushNamed(RegisterPage.routeName);
                            }, 'Register', AppColors().primaryColor),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsetsDirectional.only(
                                    bottom: 32, end: 32),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: TextButton(
                                      onPressed: () =>
                                          _openForgotPasswordBottomSheet(
                                              context),
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
