import 'package:asset_flutter/common/widgets/dropdown.dart';
import 'package:flutter/material.dart';

class RegisterCurrencyDropdown extends StatelessWidget {
  final List<String> dropdownList = ["USD", "EUR", "GBP", "KRW", "JPY"];
  late final Dropdown dropdown;
  
  @override
  Widget build(BuildContext context) {
    dropdown = Dropdown(dropdownList);

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