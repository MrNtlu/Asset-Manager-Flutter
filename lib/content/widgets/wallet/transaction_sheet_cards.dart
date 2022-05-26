import 'dart:io';

import 'package:asset_flutter/content/providers/subscription/card.dart';
import 'package:asset_flutter/content/providers/subscription/card_sheet_state.dart';
import 'package:asset_flutter/content/widgets/subscription/card_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TransactionSheetCreditCards extends StatefulWidget {
  CreditCard? selectedCard;

  TransactionSheetCreditCards({Key? key}) : super(key: key);

  @override
  State<TransactionSheetCreditCards> createState() => _TransactionSheetCreditCardsState();
}

class _TransactionSheetCreditCardsState extends State<TransactionSheetCreditCards> {
  @override
  Widget build(BuildContext context) {
    final bool isApple = Platform.isIOS || Platform.isMacOS;

    return Consumer<CardSheetSelectionStateProvider>(builder: (context, selection, _) {
      widget.selectedCard = selection.selectedCard;
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
    widget.selectedCard != null
    ? "${widget.selectedCard!.name} ${widget.selectedCard!.lastDigits}"
    : "Select Credit Card",
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
    builder: (_) => CardSelectionSheet(widget.selectedCard)
  );
}