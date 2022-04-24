import 'package:asset_flutter/content/providers/subscription/card.dart';
import 'package:flutter/material.dart';

class CardSheetSelectionStateProvider with ChangeNotifier {
  CreditCard? selectedCard;

  void cardSelectionChanged(CreditCard? creditCard) {
    if (creditCard != selectedCard) {
      selectedCard = creditCard;
      notifyListeners();
    }
  }
}
