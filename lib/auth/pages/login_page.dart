import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:asset_flutter/auth/models/requests/user.dart';
import 'package:asset_flutter/auth/models/responses/user.dart';
import 'package:asset_flutter/auth/pages/register_page.dart';
import 'package:asset_flutter/auth/widgets/auth_bottom_sheet.dart';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_snackbar.dart';
import 'package:asset_flutter/common/widgets/expanded_divider.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/shared_pref.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:asset_flutter/static/google_signin_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:asset_flutter/common/widgets/textformfield.dart';
import 'package:asset_flutter/common/widgets/password_textformfield.dart';
import 'package:asset_flutter/auth/widgets/auth_button.dart';
import 'package:asset_flutter/auth/widgets/auth_checkbox.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  static const routeName = "/login";
  final _form = GlobalKey<FormState>();
  final _loginModel = Login('', '');
  late final String token;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  DetailState _state = DetailState.init;
  late final AuthCheckbox _checkbox;
  late AssetImage _assetImage;

  void _onSigninPressed(BuildContext ctx, {Login? login}) {
    if (login == null) {
      final isValid = widget._form.currentState?.validate();
      if (isValid != null && !isValid) {
        return;
      }
      widget._form.currentState?.save();
    } 
    setState(() {
      _state = DetailState.loading;
    });

    var _login = login ?? widget._loginModel;
    _login.login().then((value) {
      if (_state != DetailState.disposed) {
        setState(() {
          _state = DetailState.loading;
        });

        if (value.message != null) {
          _onErrorDialog(true, error: value.message!);

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
      }
    });
  }

  void _onOAuth2Login(String token) async {
    try {
      var response = await http.post(
        Uri.parse(APIRoutes().oauthRoutes.google),
        body: json.encode({
          "token": token
        }),
        headers: {
          "Content-Type": "application/json",
        }
      );

      var tokenResponse = TokenResponse(
        code: json.decode(response.body)["code"],
        message: json.decode(response.body)["message"],
        token: json.decode(response.body)["access_token"],
      );

      if (_state != DetailState.disposed) {
        if (tokenResponse.message != null) {
          _onErrorDialog(true, error: tokenResponse.message!);
        } else {
          try {
            widget.token = tokenResponse.token!;
          // ignore: empty_catches
          } catch(err) {}

          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
            return TabsPage(widget.token);
          }));
        }
      }
    } catch (err) {
      if (_state != DetailState.disposed) {
        _onErrorDialog(true, error: err.toString());
      }
    }
  }

  Future _authenticate(GoogleSignInAccount user) async {
    setState(() {
      _state = DetailState.loading;
    });
    user.authentication.then((response){
      if (_state != DetailState.disposed) {
        if (response.accessToken != null) {
          _onOAuth2Login(response.accessToken!);
        } else {
          _onErrorDialog(true);
        }
      }
    }).catchError((err) {
      if (_state != DetailState.disposed) {
        _onErrorDialog(true, error: err);
      }
    });
  }

  Future _onGoogleSignInPressed() async {
    GoogleSignInApi().login().then((response) {
      if (_state != DetailState.disposed) {
        if (response != null) {
          _authenticate(response);
        }  
      }
    }).catchError((err) {
      if (_state != DetailState.disposed) {
        _onErrorDialog(false, error: err);
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
  void dispose() {
    _state = DetailState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_state == DetailState.init) {
      precacheImage(_assetImage, context);
      _checkbox = AuthCheckbox('Remember Password');
      SharedPref().init().then((_) {
        var loginCreds = SharedPref().getLoginCredentials();

        if (loginCreds.keys.first) {
          _onSigninPressed(context, login: loginCreds.values.first);
        }
      });

      GoogleSignInApi().signInSilently().then((user) {
        if (user != null) {
          _authenticate(user);
        }
      });

      _state = DetailState.view;
    }
  }

  @override
  void initState() {
    super.initState();
    _assetImage = const AssetImage("assets/images/auth_bg.jpeg");
  }

  @override
  Widget build(BuildContext context) {
    final bool isApple = Platform.isIOS || Platform.isMacOS;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: _assetImage,
            fit: BoxFit.cover
          ),
        ),
        child: SafeArea(
          child: _state == DetailState.loading
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
                            margin: const EdgeInsets.fromLTRB(16, 2, 16, 8),
                            child: Lottie.asset(
                              "assets/lottie/auth.json", 
                              fit: BoxFit.cover,
                              height: MediaQuery.of(context).size.height / 3.42,
                              frameRate: FrameRate(60)
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
                                      errorTextStyle: TextStyle(color: Colors.red.shade600, fontWeight: FontWeight.bold),
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
                                      errorTextStyle: TextStyle(color: Colors.grey.shade300, fontWeight: FontWeight.bold),
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
                                    Container(
                                      width: double.infinity,
                                      height: 45,
                                      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 3),
                                      child: SignInButton(
                                        Buttons.Google,
                                        text: "Sign In with Google",
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8)
                                        ),
                                        onPressed: _onGoogleSignInPressed,
                                      ),
                                    ),
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

  void _onErrorDialog(bool _setState, {String error = "Failed to login"}) {
    if (_setState) {
      setState(() {
        _state = DetailState.view;
      });
    }
    
    GoogleSignInApi().signOut();
    SharedPref().deleteLoginCredentials();
    
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 5),
      content: ErrorSnackbar(error),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ));
  }
}
