import 'package:asset_flutter/content/providers/market/market_selection_state.dart';
import 'package:asset_flutter/static/markets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MarketDropdowns extends StatefulWidget {
  const MarketDropdowns({Key? key}) : super(key: key);

  @override
  State<MarketDropdowns> createState() => _MarketDropdownsState();
}

class _MarketDropdownsState extends State<MarketDropdowns> {
  late List<String> _marketDropdownList;
  bool isInit = false;
  late String _typeDropdownValue;
  late String _marketDropdownValue;
  late final MarketSelectionStateProvider _marketSelectionProvider;

  @override
  void didChangeDependencies() {
    if (!isInit) {
      _marketSelectionProvider = Provider.of<MarketSelectionStateProvider>(context, listen: false);
      _typeDropdownValue = "Crypto";
      _marketDropdownList = SupportedMarkets().setMarketList("crypto");
      _marketDropdownValue = _marketDropdownList[0];
      isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                dropdownColor: Colors.white,
                value: _typeDropdownValue,
                items: const ["Crypto", "Stock", "Commodity"].map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(value),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null && value != _typeDropdownValue) {
                    setState(() {
                      _marketDropdownList = SupportedMarkets().setMarketList(value);
                      _marketDropdownValue = _marketDropdownList[0];
                      _typeDropdownValue = value;
                    });
                    _marketSelectionProvider.newMarketSelection(_typeDropdownValue.toLowerCase(), _marketDropdownValue);
                  }
                },
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                value: _marketDropdownValue,
                dropdownColor: Colors.white,
                items: _marketDropdownList.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: AutoSizeText(value),
                      ),
                    );
                  }).toList(),
                onChanged: (value) {
                  if (value != null && value != _marketDropdownValue) {
                    setState(() {
                      _marketDropdownValue = value;
                    });
                    _marketSelectionProvider.newMarketSelection(_typeDropdownValue.toLowerCase(), _marketDropdownValue);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}