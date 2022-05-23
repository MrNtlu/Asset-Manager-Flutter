import 'dart:io';

import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/add_elevated_button.dart';
import 'package:asset_flutter/content/widgets/wallet/transaction_calendar.dart';
import 'package:asset_flutter/content/widgets/wallet/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  BaseState _state = BaseState.init;
  final List<bool> isSelected = [true, false];
  
  @override
  void dispose() {
    _state = BaseState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == BaseState.init) {
      
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MediaQuery.of(context).orientation == Orientation.portrait
        ? _body()
        : SingleChildScrollView(
          child: _landscapeBody(),
        )
      )
    );
  }

  Widget _body() => Column(
    children: [
      ToggleButtons(
        borderWidth: 0,
        selectedColor: Colors.transparent,
        borderColor: Colors.transparent,
        fillColor: Colors.transparent,
        selectedBorderColor: Colors.transparent,
        disabledBorderColor: Colors.transparent,
        splashColor: Colors.transparent,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Calendar", 
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18, color: isSelected[0] ? Colors.black : Colors.grey.shade400
              )
            )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "List", 
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18, color: isSelected[1] ? Colors.black : Colors.grey.shade400
              )
            )
          ),
        ],
        isSelected: isSelected,
        onPressed: (int newIndex) {
          setState(() {
            var falseIndex = newIndex == 0 ? 1 : 0;
            if (!isSelected[newIndex]) {
              isSelected[newIndex] = true;
              isSelected[falseIndex] = false;
            }
          });
        },
      ),
      if (isSelected[0])
      const TransactionCalendar(),
      Expanded(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              const TransactionList(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                      flex: 10,
                      child: AddElevatedButton("Add Transaction", () {
                        
                      }),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: Platform.isIOS || Platform.isMacOS
                        ? CupertinoButton.filled(
                          child: const Icon(Icons.filter_alt_rounded, color: Colors.white),
                          onPressed: () {

                          },
                          padding: const EdgeInsets.all(12)
                        )
                        : ElevatedButton(
                          onPressed: () {

                          },
                          child: const Icon(Icons.filter_alt_rounded),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                            ),
                          ),
                        ),
                      )
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
    ],
  );

  Widget _landscapeBody() {
    //TODO: Implement
    return Container();
  }
}
