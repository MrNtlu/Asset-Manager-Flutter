import 'package:asset_flutter/content/widgets/subscription/cb_info_card.dart';
import 'package:flutter/material.dart';

class SubscriptionCurrencyBar extends StatefulWidget {
  const SubscriptionCurrencyBar();

  @override
  State<SubscriptionCurrencyBar> createState() => _SubscriptionCurrencyBarState();
}

class _SubscriptionCurrencyBarState extends State<SubscriptionCurrencyBar> {
  final List<String> _dropdownList = ["Monthly", "Total"];
  late String _dropdownValue;

  @override
  void initState() {
    super.initState();
    _dropdownValue = _dropdownList[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            child: Row(
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _dropdownValue,
                    items: _dropdownList.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            value,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _dropdownValue = value;
                        });
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    (_dropdownValue == "Monthly" 
                    ? "Payments"
                    : "Paid"),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CurrencyBarInfoCard(_dropdownValue == _dropdownList[0]),
        ],
      ),
    );
  }
}