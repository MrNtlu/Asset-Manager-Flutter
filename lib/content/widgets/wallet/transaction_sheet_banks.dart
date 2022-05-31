import 'dart:io';

import 'package:asset_flutter/content/providers/wallet/bank_account.dart';
import 'package:asset_flutter/content/providers/wallet/bank_account_selection_state.dart';
import 'package:asset_flutter/content/widgets/wallet/bank_account_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TransactionSheetBankAccounts extends StatefulWidget {
  BankAccount? selectedBankAcc;

  TransactionSheetBankAccounts({Key? key}) : super(key: key);

  @override
  State<TransactionSheetBankAccounts> createState() => _TransactionSheetBankAccountsState();
}

class _TransactionSheetBankAccountsState extends State<TransactionSheetBankAccounts> {
  bool isInit = false;

  @override
  void dispose() {
    isInit = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isApple = Platform.isIOS || Platform.isMacOS;

    return Consumer<BankAccountSelectionStateProvider>(builder: (context, selection, _) {
      if (isInit) {
        widget.selectedBankAcc = selection.selectedBankAcc;
      } else {
        isInit = true;
      }
      return isApple
      ? CupertinoButton(
        child: _buttonText(),
        onPressed: _onButtonPressed
      )
      : TextButton(
        child: _buttonText(),
        onPressed: _onButtonPressed,
      );
    });
  }

  Widget _buttonText() => Text(
    widget.selectedBankAcc != null
    ? "${widget.selectedBankAcc!.name} ${widget.selectedBankAcc!.currency}"
    : "Select Bank Account",
    style: const TextStyle(fontSize: 16),
  );

  void _onButtonPressed() => showModalBottomSheet(
    context: context,
    shape: Platform.isIOS || Platform.isMacOS
    ? const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(16),
        topLeft: Radius.circular(16)
      ),
    )
    : null,
    enableDrag: false,
    isDismissible: true,
    builder: (_) => BankAccountSelectionSheet(widget.selectedBankAcc)
  );
}