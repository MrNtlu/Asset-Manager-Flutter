import 'package:asset_flutter/content/providers/subscription/card.dart';
import 'package:asset_flutter/content/providers/wallet/bank_account.dart';
import 'package:asset_flutter/content/providers/wallet/transaction.dart';
import 'package:flutter/material.dart';

class TransactionSheetSelectionStateProvider with ChangeNotifier {
  DateTimeRange? selectedTimeRange;
  CreditCard? selectedCard;
  BankAccount? selectedBankAcc;
  Category? selectedCategory;
  String? sort;
  String? sortType;

  void selectionChanged(
    DateTimeRange? dateTimeRange,
    CreditCard? creditCard,
    BankAccount? bankAccount,
    Category? category,
    String sortSelection, 
    String sortTypeSelection
  ) {
    var isChanged = false;
    if (dateTimeRange != selectedTimeRange || (selectedTimeRange == null && dateTimeRange == null)) {
      selectedTimeRange = dateTimeRange;
      isChanged = true;
    }

    if (creditCard != selectedCard || (creditCard == null && selectedCard == null)) {
      selectedCard = creditCard;
      isChanged = true;
    }

    if (bankAccount != selectedBankAcc || (selectedBankAcc == null && bankAccount == null)) {
      selectedBankAcc = bankAccount;
      isChanged = true;
    }

    if (category != selectedCategory || (category == null && selectedCategory == null)) {
      selectedCategory = category;
      isChanged = true;
    }

    if (sort != sortSelection) {
      sort = sortSelection;
      isChanged = true;
    }
    if (sortType != sortTypeSelection) {
      sortType = sortTypeSelection;
      isChanged = true;
    }

    if (isChanged) {
      notifyListeners();
    }
  }

  void resetSelection({shouldNotify = true}) {
    selectedTimeRange = null;
    selectedCard = null;
    selectedBankAcc = null;
    selectedCategory = null;
    sort = "Date";
    sortType = "Descending";
    if (shouldNotify) {
      notifyListeners();
    }
  }
}
