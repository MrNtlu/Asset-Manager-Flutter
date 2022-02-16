import 'package:asset_flutter/common/widgets/dropdown.dart';
import 'package:asset_flutter/static/currencies.dart';
import 'package:flutter/material.dart';

class RegisterCurrencyDropdown extends StatelessWidget {
  late final Dropdown dropdown;
  
  RegisterCurrencyDropdown(){
    dropdown = Dropdown(SupportedCurrencies().currencies);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(32, 16, 32, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Default Currency",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          dropdown,
        ],
      ),
    );
  }
}