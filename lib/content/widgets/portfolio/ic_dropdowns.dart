import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/markets.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InvestmentCreateDropdowns extends StatefulWidget {
  late String typeDropdownValue;
  late String marketDropdownValue;

  InvestmentCreateDropdowns({Key? key}) : super(key: key);

  @override
  State<InvestmentCreateDropdowns> createState() => _InvestmentCreateDropdownsState();
}

class _InvestmentCreateDropdownsState extends State<InvestmentCreateDropdowns> {
  late List<String> _marketDropdownList;
  bool isInit = false;

  @override
  void didChangeDependencies() {
    if (!isInit) {
      widget.typeDropdownValue = "Crypto";
      _marketDropdownList = SupportedMarkets().setMarketList("crypto");
      widget.marketDropdownValue = _marketDropdownList[0];
      isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Investment Type",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: widget.typeDropdownValue,
              style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.bgTextColor),
              items: const ["Crypto", "Stock", "Exchange", "Commodity"].map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(value),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _marketDropdownList = SupportedMarkets().setMarketList(value);
                    widget.marketDropdownValue = _marketDropdownList[0];
                    widget.typeDropdownValue = value;
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Investment Market",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: widget.marketDropdownValue,
              style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.bgTextColor),
              items: _marketDropdownList.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(value),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    widget.marketDropdownValue = value;
                  });
                }
              },
            ),
          )
        ],
      ),
    );
  }
}