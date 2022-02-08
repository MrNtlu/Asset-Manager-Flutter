import 'package:asset_flutter/auth/widgets/auth_button.dart';
import 'package:asset_flutter/common/widgets/dropdown.dart';
import 'package:asset_flutter/common/widgets/password_textfield.dart';
import 'package:asset_flutter/common/widgets/textfield.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  static const routeName = "/register";

  final usernameInput = TextEditingController();
  final emailInput = TextEditingController();
  final passwordInput = TextEditingController();
  final rePasswordInput = TextEditingController();
  late final Checkbox? termsConditionsCheck;
  late final Checkbox? privacyPolicyCheck;

  void onRegisterPressed(BuildContext ctx) {
    print(
      "EmailInput: " + emailInput.text + 
      " Password: " + passwordInput.text + " " + 
      (termsConditionsCheck != null ? termsConditionsCheck!.value.toString() : "null")
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> dropdownList = ["USD", "EUR", "GBP", "KRW", "JPY"];

    final AppBar appBar = AppBar(
      title: const Text('Register'),
      backgroundColor: AppColors().primaryColor,
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
                      "Email", 
                      TextInputType.emailAddress, 
                      textfieldController: emailInput,
                      prefixIcon: Icon(
                        Icons.email,
                        color: AppColors().primaryColor
                      ),
                    ),
                    PasswordTextField(
                      passwordInput,
                      prefixIcon: Icon(
                        Icons.password,
                        color: AppColors().primaryColor
                      ),
                    ),
                    PasswordTextField(rePasswordInput, label: "Password Again"),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(32, 16, 32, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Default Currency",
                            style: TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Dropdown(dropdownList),
                        ],
                      ),
                    ),
                    AuthButton(onRegisterPressed, "Register", AppColors().primaryColor),
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