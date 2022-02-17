import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessView extends StatelessWidget {
  final String _text;
  final bool isNonTabView;

  const SuccessView(this._text, {this.isNonTabView = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            ElevatedButton(
              onPressed: (){
                if (isNonTabView) {
                  Navigator.pop(context);
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