import 'package:flutter/material.dart';

class WalletStatsPage extends StatelessWidget {
  const WalletStatsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context), 
                  icon: const Icon(Icons.arrow_back_ios_new_rounded)
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}