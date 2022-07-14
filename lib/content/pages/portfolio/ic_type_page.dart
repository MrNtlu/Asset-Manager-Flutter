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
    final _investmentCreateDropdowns = InvestmentCreateDropdowns();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Create"),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 26, 16, 8),
          child: Column(
            children: [
              _investmentCreateDropdowns,
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: isApple
                ? CupertinoButton.filled(
                  padding: const EdgeInsets.all(12),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: ((context) => InvestmentCreatePickPage(
                        _investmentCreateDropdowns.typeDropdownValue,
                        _investmentCreateDropdowns.marketDropdownValue,
                      )))
                    );
                  },
                  child: const Text("Continue", style: TextStyle(color: Colors.white))
                )
                : ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: ((context) => InvestmentCreatePickPage(
                        _investmentCreateDropdowns.typeDropdownValue,
                        _investmentCreateDropdowns.marketDropdownValue,
                      )))
                    );
                  },
                  child: const Text("Continue", style: TextStyle(color: Colors.white))
                ),
              )
            ],
          )
        )
      )
    );
  }
}