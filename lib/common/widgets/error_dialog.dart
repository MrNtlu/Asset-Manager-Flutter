import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class ErrorDialog extends StatelessWidget {
  final String _error;

  const ErrorDialog(this._error, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isApple = Platform.isIOS || Platform.isMacOS;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: const Color(0xFFC72C41),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                    child: Lottie.asset(
                      "assets/lottie/error_dialog.json",
                      width: 125,
                      height: 125,
                      repeat: true,
                      fit: BoxFit.contain,
                      frameRate: FrameRate(60),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                    child: Text(
                      _error,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  isApple
                  ? CupertinoButton(
                    child: const Text("OK!", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14)), 
                    onPressed: (){
                      Navigator.pop(context);
                    }
                  )
                  : TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    }, 
                    child: const Text("OK!")
                  ),
                  const SizedBox(height: 4)
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20)),
                child: SvgPicture.asset(
                  "assets/icons/bubbles.svg",
                  height: 48,
                  width: 40,
                  color: const Color(0xFF801336),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
