import 'package:asset_flutter/auth/models/requests/user.dart';
import 'package:asset_flutter/auth/widgets/auth_button.dart';
import 'package:asset_flutter/auth/widgets/auth_currency_dropdown.dart';
import 'package:asset_flutter/common/widgets/password_textformfield.dart';
import 'package:asset_flutter/common/widgets/textformfield.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  static const routeName = "/register";

  final rePasswordInput = TextEditingController();
  late final Checkbox? termsConditionsCheck;
  late final Checkbox? privacyPolicyCheck;

  late final RegisterCurrencyDropdown currencyDropdown;
  final _form = GlobalKey<FormState>();
  final _registerModel = Register('', '', '');

  void onRegisterPressed(BuildContext ctx) {
    _registerModel.currency = currencyDropdown.dropdown.dropdownValue;
    final isValid = _form.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }
    _form.currentState?.save();
  }

  @override
  Widget build(BuildContext context) {
    final AppBar appBar = AppBar(
      title: const Text('Register'),
      backgroundColor: AppColors().primaryColor,
    );

    currencyDropdown = RegisterCurrencyDropdown();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(top: 36),
                child: Form(
                  key: _form,
                  child: Column(children: [
                    CustomTextFormField(
                      "Email",
                      TextInputType.emailAddress,
                      prefixIcon:
                          Icon(Icons.email, color: AppColors().primaryColor),
                      onSaved: (value) {
                        if (value != null) {
                          _registerModel.emailAddress = value;
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
                      prefixIcon:
                          Icon(Icons.password, color: AppColors().primaryColor),
                      onSaved: (value) {
                        if (value != null) {
                          _registerModel.password = value;
                        }
                      },
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            return "Please don't leave this empty.";
                          } else if (value != rePasswordInput.text) {
                            return "Passwords don't match.";
                          }
                        }

                        return null;
                      },
                    ),
                    PasswordTextField(
                      passwordController: rePasswordInput,
                      label: "Password Again",
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            return "Please don't leave this empty.";
                          }
                        }

                        return null;
                      },
                    ),
                    currencyDropdown,
                    AuthButton(onRegisterPressed, "Register",
                        AppColors().primaryColor),
                  ]),
                ),
              ),
            )),
      ),
    );
  }
}
