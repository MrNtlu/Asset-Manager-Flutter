import 'package:asset_flutter/auth/widgets/auth_button.dart';
import 'package:asset_flutter/common/widgets/password_textfield.dart';
import 'package:asset_flutter/common/widgets/textfield.dart';
import 'package:asset_flutter/content/pages/tabs_page.dart';
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
      backgroundColor: TabsPage.primaryColor,
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
                        color: TabsPage.primaryColor
                      ),
                    ),
                    CustomTextField(
                      "Email", 
                      TextInputType.emailAddress, 
                      textfieldController: emailInput,
                      prefixIcon: const Icon(
                        Icons.email,
                        color: TabsPage.primaryColor
                      ),
                    ),
                    PasswordTextField(
                      passwordInput,
                      prefixIcon: const Icon(
                        Icons.password,
                        color: TabsPage.primaryColor
                      ),
                    ),
                    PasswordTextField(rePasswordInput, label: "Password Again"),
                    AuthButton(onRegisterPressed, "Register", TabsPage.primaryColor),
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