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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context), 
                        icon: const Icon(Icons.arrow_back_ios_new_rounded)
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        "Statistics",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 48,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}