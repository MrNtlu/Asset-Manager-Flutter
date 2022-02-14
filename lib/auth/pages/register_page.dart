import 'package:asset_flutter/auth/models/requests/user.dart';
import 'package:asset_flutter/auth/widgets/auth_button.dart';
import 'package:asset_flutter/auth/widgets/auth_checkbox.dart';
import 'package:asset_flutter/auth/widgets/auth_currency_dropdown.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/password_textformfield.dart';
import 'package:asset_flutter/common/widgets/textformfield.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = "/register";
  final _form = GlobalKey<FormState>();
  final _registerModel = Register('', '', '');
  bool _isInit = false;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;

  late final AuthCheckbox _termsConditionsCheck;
  late final AuthCheckbox _privacyPolicyCheck;
  late final RegisterCurrencyDropdown _currencyDropdown;
  String _rePassword = '';

  void _onRegisterPressed(BuildContext context) {
    if (_termsConditionsCheck.getValue() && _privacyPolicyCheck.getValue()) {
      widget._registerModel.currency = _currencyDropdown.dropdown.dropdownValue;
      final isValid = widget._form.currentState?.validate();
      if (isValid != null && !isValid) {
        return;
      }
      widget._form.currentState?.save();

      if (widget._registerModel.password != _rePassword) {
        showDialog(
          context: context, 
          builder: (ctx) => const ErrorDialog("Passwords don't match.")
        );
      }else {
        setState(() {
          _isLoading = true;
        });

        widget._registerModel.register().then((value){
          setState(() {
            _isLoading = false;
          });
          if (value.error != null) {
            showDialog(
              context: context, 
              builder: (ctx) => ErrorDialog(value.error!)
            );
          }else {
            //TODO: Show dialog and on ok pop
            Navigator.of(context).pop();
          }
        }).catchError((error){
          setState(() {
            _isLoading = false;
          });
        });
      }
    }else {
      showDialog(
        context: context, 
        builder: (ctx) => const ErrorDialog("Please accept Terms & Conditions and Privacy Policy")
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!widget._isInit) {
      _currencyDropdown = RegisterCurrencyDropdown();
      _termsConditionsCheck = AuthCheckbox("Terms & Conditions");
      _privacyPolicyCheck = AuthCheckbox("Privacy & Policy");

      widget._isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: AppColors().primaryColor,
      ),
      body: SafeArea(
        child: _isLoading
        ? const LoadingView("Please wait while registering...") 
        : SingleChildScrollView(
            physics: const ScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(top: 36),
                child: Form(
                  key: widget._form,
                  child: Column(children: [
                    CustomTextFormField(
                      "Email",
                      TextInputType.emailAddress,
                      initialText: widget._registerModel.emailAddress.trim() != '' 
                        ? widget._registerModel.emailAddress 
                        : null,
                      prefixIcon:
                          Icon(Icons.email, color: AppColors().primaryColor),
                      onSaved: (value) {
                        if (value != null) {
                          widget._registerModel.emailAddress = value;
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
                      initialText: widget._registerModel.password.trim() != '' 
                        ? widget._registerModel.password 
                        : null,
                      prefixIcon:
                          Icon(Icons.password, color: AppColors().primaryColor),
                      onSaved: (value) {
                        if (value != null) {
                          widget._registerModel.password = value;
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
                    PasswordTextFormField(
                      initialText: _rePassword.trim() != '' 
                        ? _rePassword 
                        : null,
                      label: "Password Again",
                      textInputAction: TextInputAction.done,
                      onSaved: (value){
                        if (value != null) {
                          _rePassword = value;
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
                    _currencyDropdown,
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(32, 4, 32, 0),
                      child: _termsConditionsCheck,
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(32, 4, 32, 0),
                      child: _privacyPolicyCheck,
                    ),
                    AuthButton((BuildContext ctx){
                      _onRegisterPressed(context);
                    }, "Register",AppColors().primaryColor),
                  ]),
                ),
              ),
            )),
      ),
    );
  }
}
