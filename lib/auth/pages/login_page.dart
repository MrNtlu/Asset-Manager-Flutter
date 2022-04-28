import 'dart:io';
import 'dart:ui';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:asset_flutter/common/widgets/textformfield.dart';
import 'package:asset_flutter/common/widgets/password_textformfield.dart';
import 'package:asset_flutter/auth/widgets/auth_button.dart';
import 'package:asset_flutter/auth/widgets/auth_checkbox.dart';
import 'package:lottie/lottie.dart';

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
      isScrollControlled: true,
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
    final bool isApple = Platform.isIOS || Platform.isMacOS;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/auth_bg.jpeg"),
            fit: BoxFit.cover
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const LoadingView("Please wait while logging in", textColor: Colors.white)
              : CustomScrollView(
                  physics: const ScrollPhysics(),
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      fillOverscroll: false,
                      child: Center(
                        child: Form(
                          key: widget._form,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                child: Lottie.asset(
                                  "assets/lottie/auth.json", 
                                  fit: BoxFit.cover,
                                  height: MediaQuery.of(context).size.height / 3.3
                                )
                              ),
                              ClipRRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(width: 2, color: Colors.white30)
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    margin: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Column(
                                      children: [
                                        CustomTextFormField(
                                          'Email',
                                          TextInputType.emailAddress,
                                          initialText: widget._loginModel.emailAddress.trim() != '' 
                                            ? widget._loginModel.emailAddress 
                                            : null,
                                          prefixIcon: Icon(
                                            Icons.email,
                                            color: AppColors().primaryDarkestColor,
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
                                          defaultBorder: _textFieldInputBorder(),
                                          enabledBorder: _textFieldInputBorder(),
                                          focusedBorder: _textFieldInputBorder(),
                                        ),
                                        PasswordTextFormField(
                                          initialText: widget._loginModel.password.trim() != '' 
                                            ? widget._loginModel.password 
                                            : null,
                                          prefixIcon: Icon(
                                            Icons.password,
                                            color: AppColors().primaryDarkestColor,
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
                                          defaultBorder: _textFieldInputBorder(),
                                          enabledBorder: _textFieldInputBorder(),
                                          focusedBorder: _textFieldInputBorder(),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            left: (Platform.isMacOS || Platform.isWindows || Platform.isIOS) ? 26 : 18,
                                            top: (Platform.isMacOS || Platform.isWindows || Platform.isIOS) ? 8 : 4,
                                            bottom: (Platform.isMacOS || Platform.isWindows || Platform.isIOS) ? 4 : 0
                                          ),
                                          child: _checkbox
                                        ),
                                        AuthButton((BuildContext ctx){
                                          _onSigninPressed(context);
                                        }, 'Sign In', AppColors().primaryLightColor),
                                        Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Row(
                                            children: const [
                                              ExpandedDivider(10, 20, 24, color: Colors.white),
                                              Text("OR", style: TextStyle(color: Colors.white)),
                                              ExpandedDivider(20, 10, 24, color: Colors.white),
                                            ],
                                          ),
                                        ),
                                        AuthButton((BuildContext ctx){
                                          Navigator.of(ctx).pushNamed(RegisterPage.routeName);
                                        }, 'Register', AppColors().primaryColor),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsetsDirectional.only(bottom: 16, end: 16),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: isApple
                                    ? CupertinoButton(
                                      padding: const EdgeInsets.all(12),
                                      onPressed: () => _openForgotPasswordBottomSheet(context),
                                      child: const Text(
                                        'Forgot Password', 
                                        style: TextStyle(color: Colors.white, fontSize: 14)
                                      )
                                    )
                                    : TextButton(
                                      onPressed: () =>_openForgotPasswordBottomSheet(context),
                                      child: const Text(
                                        'Forgot Password', 
                                        style: TextStyle(color: Colors.white, fontSize: 14)
                                      )
                                    )
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
      ),
    );
  }

  InputBorder _textFieldInputBorder() => UnderlineInputBorder(
    borderRadius: BorderRadius.circular(6),
    borderSide: const BorderSide(color: Colors.white)
  );
}
