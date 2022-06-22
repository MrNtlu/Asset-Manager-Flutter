import 'dart:convert';
import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/success_view.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'auth_button.dart';
import 'package:asset_flutter/common/widgets/textformfield.dart';
import 'package:http/http.dart' as http;

class AuthBottomSheet extends StatefulWidget {
  @override
  State<AuthBottomSheet> createState() => _AuthBottomSheetState();
}

class _AuthBottomSheetState extends State<AuthBottomSheet> {
  BaseState _state = BaseState.init;
  final _form = GlobalKey<FormState>();
  final _emailInput = TextEditingController();

  void onSendEmailPressed(BuildContext _) async {
    final isValid = _form.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }
    setState(() {
      _state = BaseState.loading;
    });
    
    try {
      final response = await http.post(
        Uri.parse(APIRoutes().userRoutes.forgotPassword),
        body: json.encode({
          "email_address": _emailInput.text,
        }),
      );

      if (response.getBaseResponse().error != null){
        showDialog(
          context: context, 
          builder: (ctx) => ErrorDialog(response.getBaseResponse().error!)
        );
        setState(() {
          _state = BaseState.init;
        });
        return;
      }

      Navigator.pop(context);
      showDialog(
        context: context, 
        builder: (ctx) => const SuccessView("sent email", shouldJustPop: true)
      );
    } catch(error) {
      showDialog(
        context: context, 
        builder: (ctx) => ErrorDialog(error.toString())
      );
      setState(() {
        _state = BaseState.init;
      });
    }
  }

  @override
  void dispose() {
    _state = BaseState.disposed;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case BaseState.init:
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            height: 220,
            margin: const EdgeInsets.all(12),
            decoration: Platform.isIOS || Platform.isMacOS
            ? const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16)
              ),
            )
            : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Form(
                  key: _form,
                  child: CustomTextFormField(
                    'Email', 
                    TextInputType.emailAddress, 
                    textfieldController: _emailInput,
                    prefixIcon: Icon(
                      Icons.email,
                      color: Theme.of(context).colorScheme.bgTextColor
                    ), 
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if(value != null) {
                        if (value.isEmpty){
                          return "Please don't leave empty.";
                        } else if (!value.isEmailValid()) {
                          return "Email is not valid.";
                        }
                      }
                
                      return null;
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(32, 8, 32, 16),
                  child: const Text(
                    "Please enter your email address. You'll receive password reset email if you have an account.",
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  )
                ),
                AuthButton(onSendEmailPressed, 'Reset', CupertinoColors.systemBlue)
              ],
            ),
          ),
        );
      default:
        return const SizedBox(
          height: 425,
          child: LoadingView("Please wait")
        );
    }
  }
}
