import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorDialog extends StatelessWidget {
  final String _error;

  const ErrorDialog(this._error, {Key? key}) : super(key: key);

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
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Lottie.asset(
                "assets/lottie/error_dialog.json",
                width: 135,
                height: 135,
                repeat: true,
                fit: BoxFit.contain
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24, top: 8),
              child: Text(
                _error,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: const Color(0xFFFC2C59)),
              onPressed: (){
                Navigator.pop(context);
              }, 
              child: const Text("OK!")
            ),
            const SizedBox(height: 4)
          ],
        ),
      ),
    );
  }
}
