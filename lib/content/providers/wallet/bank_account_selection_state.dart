import 'package:asset_flutter/content/providers/wallet/bank_account.dart';
import 'package:flutter/material.dart';

class BankAccountSelectionStateProvider with ChangeNotifier {
  BankAccount? selectedBankAcc;

  void bankAccSelectionChanged(BankAccount? bankAccount) {
    if (bankAccount != selectedBankAcc || (selectedBankAcc == null && bankAccount == null)) {
      selectedBankAcc = bankAccount;
      notifyListeners();
    }
  }

  void onDisposed() => selectedBankAcc = null;
}