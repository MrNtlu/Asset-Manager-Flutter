import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/premium_dialog.dart';
import 'package:asset_flutter/common/widgets/success_view.dart';
import 'package:asset_flutter/common/widgets/textformfield.dart';
import 'package:asset_flutter/content/models/requests/asset.dart';
import 'package:asset_flutter/content/models/responses/investings.dart';
import 'package:asset_flutter/content/providers/assets.dart';
import 'package:asset_flutter/content/widgets/portfolio/ic_dropdowns.dart';
import 'package:asset_flutter/static/currencies.dart';
import 'package:asset_flutter/static/markets.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class InvestmentCreatePage extends StatefulWidget {
  const InvestmentCreatePage({Key? key}) : super(key: key);

  @override
  State<InvestmentCreatePage> createState() => _InvestmentCreatePageState();
}

class _InvestmentCreatePageState extends State<InvestmentCreatePage> {
  final bool isApple = Platform.isIOS || Platform.isMacOS;
  final _form = GlobalKey<FormState>();
  final _investingsDropdownKey = GlobalKey<DropdownSearchState<String>>();
  final _investingCurrenciesDropdownKey = GlobalKey<DropdownSearchState<String>>();
  late final AssetsProvider _assetsProvider;
  late Orientation _orientation;

  final AssetCreate _assetCreate = AssetCreate('', '', '', -1, '', '', '', -1);
  late final List<Investings> _investingList = [];
  Investings? _selectedItem;
  Investings? _selectedCurrencyItem;
  double? _price;

  late final InvestmentCreateDropdowns _investmentCreateDropdowns;
  late final DropdownSearch<Investings> _investingsDropdown;
  late final DropdownSearch<Investings> _investingCurrenciesDropdown;

  CreateState _state = CreateState.init;
  int _currentStep = 0;
  String? _prevInvestmentType;
  String? _prevInvestmentMarket;

  void _createAssetData() {
    _assetCreate.toAsset = _selectedItem!.symbol;
    _assetCreate.name = _selectedItem!.name;
    _assetCreate.fromAsset = _selectedCurrencyItem!.symbol;
    _assetCreate.type = "buy";
    _assetCreate.assetType = _investmentCreateDropdowns.typeDropdownValue.toLowerCase();
    _assetCreate.assetMarket = _investmentCreateDropdowns.marketDropdownValue;
    _assetCreate.price = _price!;
  }

  void _createInvestment(BuildContext context) {
    if (_state == CreateState.editing) {
      if (_selectedItem == null || _selectedCurrencyItem == null) {
        setState(() {
          _currentStep = 1;
        });
        showDialog(
            context: context,
            builder: (ctx) => const ErrorDialog("Please select investment and currency."));
        return;
      }

      setState(() {
        _state = CreateState.loading;
      });

      final _isValid = _form.currentState?.validate();
      if (_isValid != null && !_isValid && _price == null) {
        setState(() {
          _state = CreateState.editing;
          _currentStep = 2;
        });
        return;
      }

      _form.currentState?.save();
      _createAssetData();

      _assetsProvider.createAsset(_assetCreate).then((value) {
        if (_state != CreateState.disposed) {
          if (value.error == null) {
            setState(() {
              _state = CreateState.success;
            });
          } else {
            if (value.error!.startsWith("Free members")) {
              showDialog(
                context: context, 
                builder: (ctx) => PremiumErrorDialog(value.error!, MediaQuery.of(context).viewPadding.top)
              );
            } else {
              showDialog(
                context: context,
                builder: (ctx) => ErrorDialog(value.error!.toString()));
            }

            setState(() {
              _state = CreateState.editing;
            });
          }
        }
      }); 
    }
  }

  @override
  void dispose() {
    _state = CreateState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == CreateState.init) {
      _investmentCreateDropdowns = InvestmentCreateDropdowns();
      _investingsDropdown = _createInvestingsDropdown();
      _investingCurrenciesDropdown = _createInvestingCurrenciesDropdown();
      _assetsProvider = Provider.of<AssetsProvider>(context, listen: false);
      _state = CreateState.editing;
    }
    _orientation = MediaQuery.of(context).orientation;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Create"),
        actions: [
          if (_state == CreateState.editing)
          IconButton(
            icon: const Icon(Icons.save_rounded),
            tooltip: 'Save Investment',
            onPressed: () => _createInvestment(context),
          )
        ],
      ),
      body: SafeArea(child: _body())
    );
  }

  Widget _body() {
    switch (_state) {
      case CreateState.success:
        return Container(
            color: Colors.black54, child: const SuccessView("created"));
      case CreateState.loading:
        return const LoadingView("Creating Investment");
      case CreateState.editing:
        return Column(
          children: [
            Expanded(
              child: Stepper(
                type: _orientation == Orientation.portrait
                    ? StepperType.vertical
                    : StepperType.horizontal,
                elevation: 0,
                controlsBuilder: (BuildContext context, ControlsDetails details) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_currentStep == 2)
                        isApple
                        ? CupertinoButton.filled(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                          onPressed: () => _createInvestment(context),
                          child: const Text("Save", style: TextStyle(color: Colors.white))
                        )
                        : ElevatedButton(
                          onPressed: () => _createInvestment(context),
                          child: const Text("Save", style: TextStyle(color: Colors.white))
                        ),
                        if (_currentStep != 2)
                        isApple
                        ? CupertinoButton.filled(
                          padding: const EdgeInsets.all(12),
                          onPressed: details.onStepContinue,
                          child: const Text("Continue", style: TextStyle(color: Colors.white))
                        )
                        : ElevatedButton(
                          onPressed: details.onStepContinue,
                          child: const Text("Continue", style: TextStyle(color: Colors.white))
                        ),
                        if (_currentStep != 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: isApple
                          ? CupertinoButton(
                              onPressed: details.onStepCancel,
                              child: const Text("Cancel")
                            )
                          : OutlinedButton(
                              onPressed: details.onStepCancel,
                              child: const Text("Cancel")
                            ),
                          ),
                      ],
                    ),
                  );
                },
                onStepTapped: (index) {
                  if (_currentStep == 0) {
                    if (
                      (_prevInvestmentType != null && _prevInvestmentType != _investmentCreateDropdowns.typeDropdownValue) ||
                      (_prevInvestmentMarket != null && _prevInvestmentMarket != _investmentCreateDropdowns.marketDropdownValue)
                    ) {
                      _investingList.clear();
                      _selectedItem = null;
                      _selectedCurrencyItem = null;
                    }
                    _prevInvestmentType = _investmentCreateDropdowns.typeDropdownValue;
                    _prevInvestmentMarket = _investmentCreateDropdowns.marketDropdownValue;
                  }

                  if (_currentStep == 1 && (_selectedItem == null || _selectedCurrencyItem == null) && index != 0) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text("Please select investment and currency.", style: TextStyle(color: Colors.white)),
                      action: SnackBarAction(label: "OK", onPressed: () => ScaffoldMessenger.of(context).removeCurrentSnackBar(), textColor: Colors.black),
                      behavior: SnackBarBehavior.fixed,
                      backgroundColor: Colors.red,
                      elevation: 0,
                    ));
                  } else {
                    setState(() {
                      _currentStep = index;
                    });
                  }
                },
                steps: getSteps(),
                currentStep: _currentStep,
                onStepContinue: () {
                  if (_currentStep == 0) {
                    if (
                      (_prevInvestmentType != null && _prevInvestmentType != _investmentCreateDropdowns.typeDropdownValue) ||
                      (_prevInvestmentMarket != null && _prevInvestmentMarket != _investmentCreateDropdowns.marketDropdownValue)
                    ) {
                      _investingList.clear();
                      _selectedItem = null;
                      _selectedCurrencyItem = null;
                    }
                    _prevInvestmentType = _investmentCreateDropdowns.typeDropdownValue;
                    _prevInvestmentMarket = _investmentCreateDropdowns.marketDropdownValue;
                  }

                  if (_currentStep == 1 && (_selectedItem == null || _selectedCurrencyItem == null)) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text("Please select investment and currency.", style: TextStyle(color: Colors.white)),
                      action: SnackBarAction(label: "OK", onPressed: () => ScaffoldMessenger.of(context).removeCurrentSnackBar(), textColor: Colors.black),
                      behavior: SnackBarBehavior.fixed,
                      backgroundColor: Colors.red,
                      elevation: 0,
                    ));
                  } else if (!(getSteps().length - 1 == _currentStep)) {
                    setState(() {
                      _currentStep += 1;
                    });
                  }
                },
                onStepCancel: () {
                  if (_currentStep != 0) {
                    setState(() {
                      _currentStep -= 1;
                    });
                  }
                },
              ),
            ),
          ],
        );
      default:
        return const LoadingView("Loading");
    }
  }

  List<Step> getSteps() => [
    Step(
      state: _currentStep == 0 ? StepState.editing : StepState.indexed,
      isActive: _currentStep >= 0,
      title: const Text("Type", style: TextStyle(fontSize: 16)),
      content: _investmentCreateDropdowns
    ),
    Step(
      state: _currentStep == 1 ? StepState.editing : StepState.indexed,
      isActive: _currentStep >= 1,
      title: const Text("Pick", style: TextStyle(fontSize: 16)),
      content: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            _investingsDropdown,
            const SizedBox(height: 16),
            _investingCurrenciesDropdown
          ],
        ),
      )
    ),
    Step(
      state: _currentStep == 2 ? StepState.editing : StepState.indexed,
      isActive: _currentStep >= 2,
      title: const Text("Details", style: TextStyle(fontSize: 16)),
      content: Form(
        key: _form,
        child: Column(
          children: [
            CustomTextFormField(
              "Amount",
              const TextInputType.numberWithOptions(
                  decimal: true, signed: true),
              initialText: _assetCreate.amount != -1
                  ? _assetCreate.amount.toString()
                  : null,
              textInputAction: TextInputAction.next,
              edgeInsets: const EdgeInsets.symmetric(vertical: 8),
              onSaved: (value) {
                if (value != null) {
                  _assetCreate.amount = double.parse(value);
                }
              },
              validator: (value) {
                if (value != null) {
                  if (value.isEmpty) {
                    return "Please don't leave this empty.";
                  } else if (double.tryParse(value) == null) {
                    return "Amount is not valid.";
                  }
                }

                return null;
              },
            ),
            CustomTextFormField(
              "Buy/Sell Price",
              const TextInputType.numberWithOptions(
                  decimal: true, signed: true),
              initialText: _price?.toString(),
              textInputAction: TextInputAction.done,
              edgeInsets: const EdgeInsets.symmetric(vertical: 8),
              onSaved: (value) {
                if (value != null) {
                  _price = double.parse(value);
                }
              },
              validator: (value) {
                if (value != null) {
                  if (value.isEmpty) {
                    return "Please don't leave this empty.";
                  } else if (double.tryParse(value) == null) {
                    return "Price is not valid.";
                  }
                }

                return null;
              },
            ),
          ],
        ),
      )
    )
  ];

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
              "?type=${_investmentCreateDropdowns.typeDropdownValue.toLowerCase()}&market=${_investmentCreateDropdowns.marketDropdownValue}"),
        );
        _investingList.addAll(response.getBaseListResponse<Investings>().data);
      }
      return _investingList;
    },
    onChanged: (Investings? investings) => _selectedItem = investings,
    itemAsString: (Investings? investings){
      if (investings != null) {
        if (_investmentCreateDropdowns.typeDropdownValue == "Stock") {
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
      if (_investingList.isEmpty && _investmentCreateDropdowns.typeDropdownValue == "exchange") {
        var response = await http.get(
          Uri.parse(APIRoutes().assetRoutes.investingsByType +
              "?type=${_investmentCreateDropdowns.typeDropdownValue.toLowerCase()}&market=${_investmentCreateDropdowns.marketDropdownValue}"),
        );
        _investingList.addAll(response.getBaseListResponse<Investings>().data);
      } else{
        List<Investings> tempList = [];
        switch (_investmentCreateDropdowns.typeDropdownValue.toLowerCase()) {
          case "stock":
            final market = SupportedCurrencies().stockCurrencies[
              SupportedMarkets().stockMarkets.indexOf(_investmentCreateDropdowns.marketDropdownValue)
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
        if (_investmentCreateDropdowns.typeDropdownValue == "Stock") {
          return investings.name;
        }

        return (investings.symbol.getCurrencyFromString() + ' - ' + investings.name);
      }
      return "";
    }
  );
}
