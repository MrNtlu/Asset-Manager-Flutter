import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/add_elevated_button.dart';
import 'package:asset_flutter/content/widgets/portfolio/section_title.dart';
import 'package:asset_flutter/content/widgets/wallet/transaction_calendar.dart';
import 'package:asset_flutter/content/widgets/wallet/transaction_list.dart';
import 'package:asset_flutter/static/colors.dart';
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

  final bannerMainTexts = [
    "Credit Cards",
    "Statistics",
    "Bank Accounts"
  ];

  final bannerSubTexts = [
    "List of credit cards and statistics",
    "Detailed statistics for transactions",
    "List of bank accounts and statistics"
  ];

  final bannerIcons = [
    Icons.credit_card_rounded,
    Icons.bar_chart_rounded,
    Icons.account_balance_rounded
  ];
  
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

  PageController controller = PageController(viewportFraction: 0.8, initialPage: 1);

  Widget _body() => Column(
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 150,
        child: PageView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          children: pageItems(),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 6),
        child: ToggleButtons(
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
                "List", 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20, color: isSelected[0] ? Colors.black : Colors.grey.shade400
                )
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "Calendar", 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20, color: isSelected[1] ? Colors.black : Colors.grey.shade400
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
      ),
      if (isSelected[1])
      const TransactionCalendar(),
      if (isSelected[0])
      SectionTitle('Transactions', ''),
      if (isSelected[0])
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

  List<Widget> pageItems() {
    List<Widget> _items = List.empty(growable: true);
    for (var i = 0; i < 3; i++) {
      _items.add(_pageItem(i));
    }

    return _items;
  }

  Widget _pageItem(int index) => Padding(
    padding: const EdgeInsets.all(8),
    child: Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: AppColors().primaryColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                offset: Offset(2.0, 2.0),
                blurRadius: 5.0,
                spreadRadius: 1.0
              )
            ]
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Icon(bannerIcons[index], size: 36, color: Colors.white)
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bannerMainTexts[index],
                style: const TextStyle(fontSize: 26.0, color: Colors.white),
              ),
              Text(
                bannerSubTexts[index],
                style: const TextStyle(fontSize: 14.0, color: Colors.white),
              )
            ],
          ),
        )
      ],
    ),
  );
}