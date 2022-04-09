import 'dart:io';

import 'package:asset_flutter/content/widgets/settings/offers_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PremiumErrorDialog extends StatelessWidget {
  final String _message;

  const PremiumErrorDialog(this._message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isApple = Platform.isIOS || Platform.isMacOS;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 6),
              child: Lottie.asset(
                "assets/lottie/premium.json",
                height: 90,
                width: 90
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(8, 16, 8, 16),
              child: Text(
                "${_message[0].toUpperCase()}${_message.substring(1)}.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                isApple
                ? CupertinoButton.filled(
                  padding: const EdgeInsets.all(12),
                  child: Text('Membership Plans'), 
                  onPressed: () => showModalBottomSheet(
                    context: context, 
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        topLeft: Radius.circular(12)
                      ),
                    ),
                    enableDrag: true,
                    builder: (_) => const OffersSheet()
                  )
                )
                : ElevatedButton(
                  onPressed: () => showModalBottomSheet(
                    context: context, 
                    shape: RoundedRectangleBorder(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        topLeft: Radius.circular(12)
                      ),
                    ),
                    enableDrag: true,
                    builder: (_) => const OffersSheet()
                  ), 
                  child: Text('Membership Plans'),
                ),
                isApple
                ? CupertinoButton(
                  child: const Text("OK!"), 
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
                const SizedBox(height: 16)
              ],
            ),
            const SizedBox(height: 8)
          ],
        ),
      ),
    );
  }
}