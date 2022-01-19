import 'dart:io';
import 'package:asset_flutter/common/textfield.dart';
import 'package:asset_flutter/common/password_textfield.dart';
import 'package:flutter/material.dart';
import 'auth/widgets/auth_button.dart';
import 'common/expanded_divider.dart';
import 'package:desktop_window/desktop_window.dart';
import 'auth/widgets/auth_checkbox.dart';

void main() {
  setWindowForPC();
  runApp(const MyApp());
}

Future setWindowForPC() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isMacOS) {
    const minSize = Size(525, 850);
    DesktopWindow.setMinWindowSize(minSize);
    DesktopWindow.setWindowSize(minSize);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue, 
          scaffoldBackgroundColor: Colors.white,
        ),
        home: LoginPage());
  }
}

class LoginPage extends StatelessWidget {
  final emailInput = TextEditingController();
  final passwordInput = TextEditingController();
  AuthCheckbox? checkbox;

  void onSigninPressed() {
    print("EmailInput: " + emailInput.text + " Password: " + passwordInput.text + " " + (checkbox != null ? checkbox!.getValue().toString() : "null"));
  }

  void onForgotPasswordPressed() {
    print("Forgot password");
  }

  void onRegisterPressed() {
    print("Register");
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
                  CustomTextField('Email', TextInputType.emailAddress,
                      textfieldController: emailInput),
                  PasswordTextField(passwordInput),
                  Container(
                      margin: EdgeInsets.only(
                          left: (Platform.isMacOS || Platform.isWindows) ? 26 : 18,
                          top: (Platform.isMacOS || Platform.isWindows) ? 8 : 4
                      ),
                      child: checkbox
                  ),
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
                            onPressed: onForgotPasswordPressed,
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
