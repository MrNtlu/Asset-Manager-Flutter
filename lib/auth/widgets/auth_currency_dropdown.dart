import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/currency_sheet.dart';
import 'package:asset_flutter/content/providers/common/currency_sheet_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore_for_file: must_be_immutable
class RegisterCurrencyDropdown extends StatefulWidget {
  String currency;
  final Color textColor;
  
  RegisterCurrencyDropdown({this.currency = "USD", this.textColor = Colors.black});

  @override
  State<RegisterCurrencyDropdown> createState() => _RegisterCurrencyDropdownState();
}

class _RegisterCurrencyDropdownState extends State<RegisterCurrencyDropdown> {
  ViewState _state = ViewState.init;

  late final CurrencySheetSelectionStateProvider _provider;

  void _currencySheetListener() {
    if (_state != ListState.disposed && _provider.symbol != null) {
      setState(() {
        widget.currency = _provider.symbol!;
      });
    }
  }

  @override
  void dispose() {
    _provider.removeListener(_currencySheetListener);
    _state = ViewState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ViewState.init) {
      _provider = Provider.of<CurrencySheetSelectionStateProvider>(context);
      _provider.addListener(_currencySheetListener);

      _state = ViewState.done;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(32, 16, 32, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Default Currency",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: widget.textColor
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(width: 1, color: Colors.white30)
            ),
            child: Platform.isIOS || Platform.isMacOS
            ? CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: _buttonText(), 
              onPressed: _buttonOnPressed
            )
            : TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2)
              ),
              child: _buttonText(),
              onPressed: _buttonOnPressed,
            ),
          )
        ],
      ),
    );
  }

  Widget _buttonText() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        widget.currency, 
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
      ),
      const Icon(
        Icons.arrow_drop_down_rounded, 
        size: 30,
        color: Colors.white,
      )
    ],
  );

  void _buttonOnPressed() => showModalBottomSheet(
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
    isScrollControlled: true,
    builder: (_) => CurrencySheet(selectedSymbol: widget.currency)
  );
}