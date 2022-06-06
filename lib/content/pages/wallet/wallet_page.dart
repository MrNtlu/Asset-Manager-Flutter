import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/add_elevated_button.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/content/pages/wallet/transaction_create_page.dart';
import 'package:asset_flutter/content/providers/wallet/transaction_sheet_state.dart';
import 'package:asset_flutter/content/widgets/wallet/transaction_filter_sheet.dart';
import 'package:asset_flutter/content/widgets/wallet/transaction_list.dart';
import 'package:asset_flutter/content/widgets/wallet/wallet_stats.dart';
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
  late final TransactionSheetSelectionStateProvider _provider;

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
  
  @override
  void dispose() {
    _provider.resetSelection(shouldNotify: false);
    _state = BaseState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == BaseState.init) {
      _provider = Provider.of<TransactionSheetSelectionStateProvider>(context, listen: false);
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
      const SizedBox(
        height: 155,
        child: WalletStats()
      ),
      Expanded(
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
      )
    ],
  );

  Widget _landscapeBody() => Column(
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 155,
        child: const WalletStats(),
      ),
      const TransactionList()
    ],
  );
}