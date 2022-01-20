import 'package:asset_flutter/auth/widgets/auth_button.dart';
import 'package:asset_flutter/common/widgets/password_textfield.dart';
import 'package:asset_flutter/common/widgets/textfield.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  static const routeName = "/register";

  final usernameInput = TextEditingController();
  final emailInput = TextEditingController();
  final passwordInput = TextEditingController();
  final rePasswordInput = TextEditingController();
  Checkbox? termsConditionsCheck;
  Checkbox? privacyPolicyCheck;

  void onRegisterPressed(BuildContext ctx) {
    print(
      "EmailInput: " + emailInput.text + 
      " Password: " + passwordInput.text + " " + 
      (termsConditionsCheck != null ? termsConditionsCheck!.value.toString() : "null")
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppBar appBar = AppBar(
      title: const Text('Register'),
    );
    
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
              child: Container(
                margin: const EdgeInsets.only(top: 36),
                child: Column(
                  children: [
                    CustomTextField(
                      "Username", 
                      TextInputType.name, 
                      textfieldController: usernameInput, 
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Color(0xFF00579B),
                      ),
                    ),
                    CustomTextField(
                      "Email", 
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
                    PasswordTextField(rePasswordInput, label: "Password Again"),
                    AuthButton(onRegisterPressed, "Register", Colors.blue.shade800),
                  ]
                ),
              ),
            ),
          )
        ]
      ),
    );
  }
}