import 'dart:convert';
import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/base_button.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/success_view.dart';
import 'package:asset_flutter/common/widgets/textformfield.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _form = GlobalKey<FormState>();
  BaseState _state = BaseState.init;
  String? _email;
  String? _message;

  void _onErrorOccured(String error) {
    setState(() {
      _state = BaseState.init;
    });

    Platform.isMacOS || Platform.isIOS
    ? showCupertinoDialog(
      context: context, 
      builder: (_) => ErrorDialog(error)
    )
    : showDialog(
      context: context, 
      builder: (_) => ErrorDialog(error)
    );
  }

  void _onSavePressed() async {
    final isApple = Platform.isMacOS || Platform.isIOS;
    final isValid = _form.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }
    _form.currentState?.save();

    setState(() {
      _state = BaseState.loading;  
    });

    try {
      await http.post(
        Uri.parse(dotenv.env['FORMSPREE_URI'] ?? ''),
        body: json.encode({
          'email': _email,
          'message': _message
        }),
      ).then((_) {
        isApple
        ? showCupertinoDialog(
          context: context, 
          builder: (_) => const SuccessView("Thank you for your feedback/suggestion", isNonTabView: true)
        )
        : showDialog(
          context: context, 
          builder: (_) => const SuccessView("Thank you for your feedback/suggestion", isNonTabView: true)
        );
      }).catchError((error) {
        _onErrorOccured(error.toString());
      });
    } catch (error) {
      _onErrorOccured(error.toString());
    }
  }

  @override
  void dispose() {
    _state = BaseState.disposed;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          "Feedback/Suggestion",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: _body(),
      )
    );
  }

  Widget _body() {
    switch (_state) {
      case BaseState.init:
        return SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              children: [
                CustomTextFormField(
                  "Your Email", 
                  TextInputType.emailAddress,
                  edgeInsets: const EdgeInsets.fromLTRB(16, 32, 16, 0),
                  onSaved: (value) {
                    if (value != null) {
                      _email = value;
                    }
                  },
                  validator: (value) {
                    if (value != null) {
                      if (!value.isEmailValid()) {
                        return "Email is not valid.";
                      }
                    }
        
                    return null;
                  },
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: MediaQuery.of(context).size.height ~/ 35,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                      border: OutlineInputBorder(),
                      labelText: "Message",
                      alignLabelWithHint: true,
                    ),
                    onSaved: (value) {
                      if (value != null) {
                        _message = value;
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
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  width: double.infinity,
                  child: BaseButton(
                    "Send", 
                    _onSavePressed, 
                    icon: const Icon(Icons.send_rounded, size: 22), 
                    containerMargin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24)
                  ),
                )
              ],
            ),
          ),
        );
      case BaseState.loading:
        return const LoadingView("Please wait");
      default:
        return const LoadingView("Loading");
    }
  }
}