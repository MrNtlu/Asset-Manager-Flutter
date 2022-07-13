import 'dart:io';

import 'package:asset_flutter/common/widgets/textformfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InvestmentCreateDetailsPage extends StatelessWidget {
  const InvestmentCreateDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isApple = Platform.isIOS || Platform.isMacOS;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Column(
            children: [
              CustomTextFormField(
                "Amount",
                const TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                // initialText: _assetCreate.amount != -1
                //     ? _assetCreate.amount.toString()
                //     : null,
                textInputAction: TextInputAction.next,
                edgeInsets: const EdgeInsets.symmetric(vertical: 8),
                onSaved: (value) {
                  // if (value != null) {
                  //   _assetCreate.amount = double.parse(value);
                  // }
                },
                validator: (value) {
                  if (value != null) {
                    if (value.isEmpty) {
                      return "Please don't leave this empty.";
                    } else if (double.tryParse(value) == null) {
                      return "Amount is not valid.";
                    }
                  }
      
                  return null;
                },
              ),
              CustomTextFormField(
                "Buy/Sell Price",
                const TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                // initialText: _price?.toString(),
                textInputAction: TextInputAction.done,
                edgeInsets: const EdgeInsets.symmetric(vertical: 8),
                onSaved: (value) {
                  // if (value != null) {
                  //   _price = double.parse(value);
                  // }
                },
                validator: (value) {
                  if (value != null) {
                    if (value.isEmpty) {
                      return "Please don't leave this empty.";
                    } else if (double.tryParse(value) == null) {
                      return "Price is not valid.";
                    }
                  }
      
                  return null;
                },
              ),
              Row(
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
                        Navigator.pushNamedAndRemoveUntil(context, "/tabs", (route) => false);
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
              )
            ],
          ),
        ),
      ),
    );
  }
}