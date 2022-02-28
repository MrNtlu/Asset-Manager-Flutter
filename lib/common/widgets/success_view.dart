import 'dart:io';

import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessView extends StatelessWidget {
  final String _text;
  final bool isNonTabView;
  final bool shouldJustPop;

  const SuccessView(this._text, {this.isNonTabView = false, this.shouldJustPop = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isApple = Platform.isIOS || Platform.isMacOS;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Lottie.asset(
                "assets/lottie/check_mark.json",
                width: 125,
                height: 125,
                repeat: false,
                fit: BoxFit.contain
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                "Successfully $_text.",
                style: TextStyle(
                  color: AppColors().greenColor,
                  fontSize: 18
                ),
              ),
            ),
            isApple
            ? CupertinoButton(
              child:  const Text("Done"),
              onPressed: (){
                if (isNonTabView) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                } else if (shouldJustPop) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushNamedAndRemoveUntil(context, "/tabs", (route) => false);
                }
              }
            )
            : ElevatedButton(
              onPressed: (){
                if (isNonTabView) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                } else if (shouldJustPop) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushNamedAndRemoveUntil(context, "/tabs", (route) => false);
                }
              }, 
              child: const Text("Done")
            ),
            const SizedBox(height: 6)
          ],
        ),
      ),
    );
  }
}