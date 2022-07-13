import 'dart:io';
import 'package:asset_flutter/content/models/responses/investings.dart';
import 'package:asset_flutter/content/pages/portfolio/ic_details_page.dart';
import 'package:asset_flutter/content/pages/portfolio/investment_create_page.dart';
import 'package:asset_flutter/static/currencies.dart';
import 'package:asset_flutter/static/markets.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InvestmentCreatePickPage extends StatelessWidget {
  InvestmentCreatePickPage({Key? key}) : super(key: key);

  final List<Investings> _investingList = [];
  final _investingsDropdownKey = GlobalKey<DropdownSearchState<String>>();
  final _investingCurrenciesDropdownKey = GlobalKey<DropdownSearchState<String>>();

  Investings? _selectedItem;
  Investings? _selectedCurrencyItem;

  @override
  Widget build(BuildContext context) {
    final bool isApple = Platform.isIOS || Platform.isMacOS;

    final DropdownSearch<Investings> _investingsDropdown = _createInvestingsDropdown();
    final DropdownSearch<Investings> _investingCurrenciesDropdown = _createInvestingCurrenciesDropdown();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Select Investment"),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Column(
            children: [
              _investingsDropdown,
              const SizedBox(height: 16),
              _investingCurrenciesDropdown,
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isApple
                    ? CupertinoButton(
                        onPressed: () {
                          
                        },
                        child: const Text("Cancel")
                      )
                    : OutlinedButton(
                        onPressed: () {    
                        },
                        child: const Text("Cancel")
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: isApple
                      ? CupertinoButton.filled(
                        padding: const EdgeInsets.all(12),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: ((context) => const InvestmentCreateDetailsPage()))
                          );
                        },
                        child: const Text("Continue", style: TextStyle(color: Colors.white))
                      )
                      : ElevatedButton(
                        onPressed: () {
                          
                        },
                        child: const Text("Continue", style: TextStyle(color: Colors.white))
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  DropdownSearch<Investings> _createInvestingsDropdown() => DropdownSearch<Investings>(
    key: _investingsDropdownKey,
    showSearchBox: true,
    dropdownSearchDecoration: const InputDecoration(
      label: Text('Investment'),
      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
      border: OutlineInputBorder(),
    ),
    showClearButton: true,
    onFind: (String? _) async {
      if (_investingList.isEmpty) {
        var response = await http.get(
          Uri.parse(APIRoutes().assetRoutes.investingsByType +
              "?type=crypto&market=CoinMarketCap"),
        );
        _investingList.addAll(response.getBaseListResponse<Investings>().data);
      }
      return _investingList;
    },
    onChanged: (Investings? investings) => _selectedItem = investings,
    itemAsString: (Investings? investings){
      if (investings != null) {
        // if (_investmentCreateDropdowns.typeDropdownValue == "Stock") {
        //   return investings.name;
        // }
        return (investings.symbol.getCurrencyFromString() + ' - ' + investings.name);
      }
      return "";
    }
  );

  DropdownSearch<Investings> _createInvestingCurrenciesDropdown() => DropdownSearch<Investings>(
    key: _investingCurrenciesDropdownKey,
    showSearchBox: true,
    dropdownSearchDecoration: const InputDecoration(
      label: Text('Currency'),
      contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
      border: OutlineInputBorder(),
    ),
    showClearButton: true,
    onFind: (String? _) async {
      // if (_investingList.isEmpty && _investmentCreateDropdowns.typeDropdownValue == "exchange") {
      //   var response = await http.get(
      //     Uri.parse(APIRoutes().assetRoutes.investingsByType +
      //         "?type=${_investmentCreateDropdowns.typeDropdownValue.toLowerCase()}&market=${_investmentCreateDropdowns.marketDropdownValue}"),
      //   );
      //   _investingList.addAll(response.getBaseListResponse<Investings>().data);
      // } else{
        List<Investings> tempList = [];
        switch ("crypto") {
          case "stock":
            final market = SupportedCurrencies().stockCurrencies[
              SupportedMarkets().stockMarkets.indexOf("crypto")
            ];
            tempList.add(
              Investings(
                market,
                market
              )
            );
            return tempList;
          case "commodity":
          case "crypto":
            tempList.add(const Investings("American Dollar", "USD"));
            return tempList;
        }
      // }
      return _investingList;
    },
    onChanged: (Investings? investings) => _selectedCurrencyItem = investings,
    itemAsString: (Investings? investings){
      if (investings != null) {
        // if (_investmentCreateDropdowns.typeDropdownValue == "Stock") {
        //   return investings.name;
        // }

        return (investings.symbol.getCurrencyFromString() + ' - ' + investings.name);
      }
      return "";
    }
  );
}