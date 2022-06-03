import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/add_elevated_button.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/content/pages/subscription/card_page.dart';
import 'package:asset_flutter/content/pages/wallet/bank_account_page.dart';
import 'package:asset_flutter/content/pages/wallet/transaction_create_page.dart';
import 'package:asset_flutter/content/providers/wallet/transaction_date_state.dart';
import 'package:asset_flutter/content/providers/wallet/transaction_sheet_state.dart';
import 'package:asset_flutter/content/widgets/wallet/transaction_calendar.dart';
import 'package:asset_flutter/content/widgets/wallet/transaction_filter_sheet.dart';
import 'package:asset_flutter/content/widgets/wallet/transaction_list.dart';
import 'package:asset_flutter/content/widgets/wallet/wallet_stats.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  BaseState _state = BaseState.init;
  final List<bool> isSelected = [true, false];
  late final TransactionSheetSelectionStateProvider _provider;
  late final TransactionDateRangeSelectionStateProvider _dateSelectionProvider;

  final bannerMainTexts = [
    "Credit Cards",
    "Bank Accounts"
  ];

  final bannerSubTexts = [
    "List of credit cards and statistics",
    "List of bank accounts and statistics"
  ];

  final bannerIcons = [
    Icons.credit_card_rounded,
    Icons.account_balance_rounded
  ];

  void onDateRangeSelectionListener() {
    setState(() {
      isSelected[0] = true;
      isSelected[1] = false;
    });
  }
  
  @override
  void dispose() {
    _provider.resetSelection(shouldNotify: false);
    _dateSelectionProvider.removeListener(onDateRangeSelectionListener);
    _state = BaseState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == BaseState.init) {
      _provider = Provider.of<TransactionSheetSelectionStateProvider>(context, listen: false);
      _dateSelectionProvider = Provider.of<TransactionDateRangeSelectionStateProvider>(context);
      _dateSelectionProvider.addListener(onDateRangeSelectionListener);
      _state = BaseState.loading;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _state == BaseState.loading
        ?  MediaQuery.of(context).orientation == Orientation.portrait
          ? _body()
          : SingleChildScrollView(
            child: _landscapeBody(),
          )
        : const LoadingView("Loading") 
      )
    );
  }

  PageController controller = PageController(viewportFraction: 0.8, initialPage: 1);

  Widget _body() => Column(
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 135,
        child: PageView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          children: pageItems(),
        ),
      ),
      // Padding(
      //   padding: const EdgeInsets.only(top: 6),
      //   child: ToggleButtons(
      //     borderWidth: 0,
      //     selectedColor: Colors.transparent,
      //     borderColor: Colors.transparent,
      //     fillColor: Colors.transparent,
      //     selectedBorderColor: Colors.transparent,
      //     disabledBorderColor: Colors.transparent,
      //     splashColor: Colors.transparent,
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 8),
      //         child: Text(
      //           "List", 
      //           style: TextStyle(
      //             fontWeight: FontWeight.bold,
      //             fontSize: 20, color: isSelected[0] ? Colors.black : Colors.grey.shade400
      //           )
      //         )
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 8),
      //         child: Text(
      //           "Calendar", 
      //           style: TextStyle(
      //             fontWeight: FontWeight.bold,
      //             fontSize: 20, color: isSelected[1] ? Colors.black : Colors.grey.shade400
      //           )
      //         )
      //       ),
      //     ],
      //     isSelected: isSelected,
      //     onPressed: (int newIndex) {
      //       setState(() {
      //         var falseIndex = newIndex == 0 ? 1 : 0;
      //         if (!isSelected[newIndex]) {
      //           isSelected[newIndex] = true;
      //           isSelected[falseIndex] = false;
      //         }
      //       });
      //     },
      //   ),
      // ),
      if (isSelected[1])
      const TransactionCalendar(),
      if (isSelected[0])
      Expanded(
        child: Container(
          color: Colors.white,
          margin: const EdgeInsets.only(top: 8),
          child: Stack(
            children: [
              const TransactionList(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                      flex: 10,
                      child: AddElevatedButton("Add Transaction", () =>
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: ((_) => const TransactionCreatePage(true)))
                        )
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: Platform.isIOS || Platform.isMacOS
                        ? CupertinoButton.filled(
                          child: const Icon(Icons.filter_alt_rounded, color: Colors.white),
                          onPressed: () => showModalBottomSheet(
                            context: context, 
                            builder: (_) => const TransactionFilterSheet()
                          ),
                          padding: const EdgeInsets.all(12)
                        )
                        : ElevatedButton(
                          onPressed: () => showModalBottomSheet(
                            context: context, 
                            builder: (_) => const TransactionFilterSheet()
                          ),
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
      if (i == 1) {
        _items.add(const WalletStats());
      } else {
        _items.add(_pageItem(i));
      }
    }

    return _items;
  }

  Widget _pageItem(int index) => Padding(
    padding: const EdgeInsets.all(8),
    child: InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: ((_) {
            switch (index) {
              case 0:
                return const CardPage();
              case 2:
                return const BankAccountPage();
              default:
                return const CardPage();
            }
          }))
        );
      },
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
            child: Icon(bannerIcons[index == 2 ? 1 : index], size: 36, color: Colors.white)
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bannerMainTexts[index == 2 ? 1 : index],
                  style: const TextStyle(fontSize: 26.0, color: Colors.white),
                ),
                Text(
                  bannerSubTexts[index == 2 ? 1 : index],
                  style: const TextStyle(fontSize: 14.0, color: Colors.white),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}