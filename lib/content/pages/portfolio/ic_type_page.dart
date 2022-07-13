import 'dart:io';

import 'package:asset_flutter/content/pages/portfolio/ic_pick_page.dart';
import 'package:asset_flutter/content/widgets/portfolio/ic_dropdowns.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InvestmentCreateTypePage extends StatelessWidget {
  const InvestmentCreateTypePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isApple = Platform.isIOS || Platform.isMacOS;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Select Type"),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Column(
            children: [
              InvestmentCreateDropdowns(),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isApple
                    ? CupertinoButton(
                        onPressed: () {
                          
                        },
                        child: const Text("Cancel")
                      )
                    : OutlinedButton(
                        onPressed: () {    
                        },
                        child: const Text("Cancel")
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: isApple
                      ? CupertinoButton.filled(
                        padding: const EdgeInsets.all(12),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: ((context) => InvestmentCreatePickPage()))
                          );
                        },
                        child: const Text("Continue", style: TextStyle(color: Colors.white))
                      )
                      : ElevatedButton(
                        onPressed: () {
                          
                        },
                        child: const Text("Continue", style: TextStyle(color: Colors.white))
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        )
      )
    );
  }
}