import 'dart:io';
import 'package:asset_flutter/content/models/responses/investings.dart';
import 'package:asset_flutter/content/pages/portfolio/ic_details_page.dart';
import 'package:asset_flutter/content/widgets/portfolio/il_cell_image.dart';
import 'package:asset_flutter/static/currencies.dart';
import 'package:asset_flutter/static/images.dart';
import 'package:asset_flutter/static/markets.dart';
import 'package:asset_flutter/static/purchase_api.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:asset_flutter/utils/stock_handler.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class InvestmentCreatePickPage extends StatelessWidget {
  final String investmentType;
  final String investmentMarket;

  InvestmentCreatePickPage(this.investmentType, this.investmentMarket, {Key? key}) : super(key: key);

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

    final String image;
    if (investmentType == "Crypto") {
      image = PlaceholderImages().cryptoImage("generic");
    } else if (investmentType == "Exchange") {
      image = PlaceholderImages().exchangeImage(PurchaseApi().userInfo?.currency ?? "USD");
    } else if (investmentType == "Stock") {
      image = "icons/flags/png/${convertIndexNameToFlag(investmentMarket)}.png";
    } else {
      image = 'assets/images/gold.png';
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: const [
          IconButton(
            icon: Icon(Icons.save_rounded),
            iconSize: 0,
            onPressed: null,
          )
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InvestmentListCellImage(
              image,
              investmentType.toLowerCase(), 
              size: 17,
              borderRadius: BorderRadius.circular(19),
              margin: const EdgeInsets.only(right: 8),
            ),
            Text(investmentType),
          ],
        ),
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
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel")
                      )
                    : OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel")
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: isApple
                      ? CupertinoButton.filled(
                        padding: const EdgeInsets.all(12),
                        onPressed: () {
                          if (_selectedItem != null && _selectedCurrencyItem != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: ((context) => InvestmentCreateDetailsPage(
                                _selectedItem!, 
                                _selectedCurrencyItem!,
                                investmentType,
                                investmentMarket
                              )))
                            );
                          } else {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text("Please select investment and currency.", style: TextStyle(color: Colors.white)),
                              action: SnackBarAction(label: "OK", onPressed: () => ScaffoldMessenger.of(context).removeCurrentSnackBar(), textColor: Colors.black),
                              behavior: SnackBarBehavior.fixed,
                              backgroundColor: Colors.red,
                              duration: const Duration(seconds: 2),
                              elevation: 0,
                            ));
                          }
                        },
                        child: const Text("Continue", style: TextStyle(color: Colors.white))
                      )
                      : ElevatedButton(
                        onPressed: () {
                          if (_selectedItem != null && _selectedCurrencyItem != null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: ((context) => InvestmentCreateDetailsPage(
                                _selectedItem!, 
                                _selectedCurrencyItem!,
                                investmentType,
                                investmentMarket
                              )))
                            );
                          } else {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text("Please select investment and currency.", style: TextStyle(color: Colors.white)),
                              action: SnackBarAction(label: "OK", onPressed: () => ScaffoldMessenger.of(context).removeCurrentSnackBar(), textColor: Colors.black),
                              behavior: SnackBarBehavior.fixed,
                              backgroundColor: Colors.red,
                              elevation: 0,
                            ));
                          }
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
              "?type=${investmentType.toLowerCase()}&market=$investmentMarket"),
        );
        _investingList.addAll(response.getBaseListResponse<Investings>().data);
      }
      return _investingList;
    },
    onChanged: (Investings? investings) => _selectedItem = investings,
    itemAsString: (Investings? investings){
      if (investings != null) {
        if (investmentType == "Stock") {
          return investings.name;
        }
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
      if (_investingList.isEmpty && investmentType == "exchange") {
        var response = await http.get(
          Uri.parse(APIRoutes().assetRoutes.investingsByType +
              "?type=${investmentType.toLowerCase()}&market=$investmentMarket"),
        );
        _investingList.addAll(response.getBaseListResponse<Investings>().data);
      } else{
        List<Investings> tempList = [];
        switch (investmentType.toLowerCase()) {
          case "stock":
            final market = SupportedCurrencies().stockCurrencies[
              SupportedMarkets().stockMarkets.indexOf(investmentMarket)
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
      }
      return _investingList;
    },
    onChanged: (Investings? investings) => _selectedCurrencyItem = investings,
    itemAsString: (Investings? investings){
      if (investings != null) {
        if (investmentType == "Stock") {
          return investings.name;
        }

        return (investings.symbol.getCurrencyFromString() + ' - ' + investings.name);
      }
      return "";
    }
  );
}