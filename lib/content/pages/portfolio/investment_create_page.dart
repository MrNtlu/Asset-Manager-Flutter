import 'dart:io';

import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/dropdown.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/success_view.dart';
import 'package:asset_flutter/common/widgets/textformfield.dart';
import 'package:asset_flutter/content/models/requests/asset.dart';
import 'package:asset_flutter/content/models/responses/investings.dart';
import 'package:asset_flutter/content/providers/assets.dart';
import 'package:asset_flutter/content/widgets/portfolio/ic_dropdowns.dart';
import 'package:asset_flutter/content/widgets/portfolio/investment_toggle_button.dart';
import 'package:asset_flutter/static/colors.dart';
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

  final AssetCreate _assetCreate = AssetCreate('', '', '', -1, '', '', '', -1);
  late final List<Investings> _investingList = [];
  Investings? _selectedItem;
  Investings? _selectedCurrencyItem;
  double? _price;

  late final InvestmentCreateDropdowns _investmentCreateDropdowns;
  late final DropdownSearch<Investings> _investingsDropdown;
  late final DropdownSearch<Investings> _investingCurrenciesDropdown;
  late final InvestmentToggleButton _toggleButton;

  CreateState _state = CreateState.init;
  int _currentStep = 0;
  String? _prevInvestmentType;
  String? _prevInvestmentMarket;

  void _createAssetData() {
    _assetCreate.toAsset = _selectedItem!.symbol;
    _assetCreate.name = _selectedItem!.name;
    _assetCreate.fromAsset = _selectedCurrencyItem!.symbol;
    _assetCreate.type = _toggleButton.isSelected[0] ? "buy" : "sell";
    _assetCreate.assetType = _investmentCreateDropdowns.typeDropdownValue.toLowerCase();
    _assetCreate.assetMarket = _investmentCreateDropdowns.marketDropdownValue;
    _assetCreate.price = _price!;
  }

  void _createInvestment(BuildContext context) {
    if (_selectedItem == null || _selectedCurrencyItem == null) {
      setState(() {
        _currentStep = 1;
      });
      showDialog(
          context: context,
          builder: (ctx) => const ErrorDialog("Please select investment and currency."));
      return;
    }

    final _isValid = _form.currentState?.validate();
    if (_isValid != null && !_isValid && _price == null) {
      setState(() {
        _currentStep = 2;
      });
      return;
    }

    setState(() {
      _state = CreateState.loading;
    });

    _form.currentState?.save();
    _createAssetData();

    _assetsProvider.createAsset(_assetCreate).then((value) {
      if (_state != CreateState.disposed) {
        setState(() {
          if (value.error == null) {
            _state = CreateState.success;
          } else {
            showDialog(
                context: context,
                builder: (ctx) => ErrorDialog(value.error!.toString()));
            _state = CreateState.editing;
          }
        });
      }
    });
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
      _toggleButton = InvestmentToggleButton();
      _assetsProvider = Provider.of<AssetsProvider>(context, listen: false);
    }
    _state = CreateState.editing;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Create"),
          backgroundColor: AppColors().primaryLightishColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.save_rounded),
              tooltip: 'Save Investment',
              onPressed: () => _createInvestment(context),
            )
          ],
        ),
        body: SafeArea(child: _body()));
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
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 8, bottom: 12),
              child: _toggleButton,
            ),
            Expanded(
              child: Stepper(
                type: MediaQuery.of(context).orientation == Orientation.portrait
                    ? StepperType.vertical
                    : StepperType.horizontal,
                elevation: 0,
                controlsBuilder: (BuildContext context, ControlsDetails details) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_currentStep != 2)
                          isApple
                              ? CupertinoButton.filled(
                                  padding: const EdgeInsets.all(12),
                                  onPressed: details.onStepContinue,
                                  child: const Text("Continue"))
                              : ElevatedButton(
                                  onPressed: details.onStepContinue,
                                  child: const Text("Continue")),
                        if (_currentStep != 0)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: isApple
                                ? CupertinoButton(
                                    onPressed: details.onStepCancel,
                                    child: const Text("Cancel"))
                                : OutlinedButton(
                                    onPressed: details.onStepCancel,
                                    child: const Text("Cancel")),
                          )
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
                    showDialog(
                      context: context,
                      builder: (ctx) => const ErrorDialog("Please select investment and currency.")
                    );
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
                    showDialog(
                      context: context,
                      builder: (ctx) => const ErrorDialog("Please select investment and currency.")
                    );
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
            SizedBox(height: 16),
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
              "Buy/Sell Price",
              const TextInputType.numberWithOptions(
                  decimal: true, signed: true),
              initialText: _price != null ? _price.toString() : null,
              textInputAction: TextInputAction.next,
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
            CustomTextFormField(
              "Amount",
              const TextInputType.numberWithOptions(
                  decimal: true, signed: true),
              initialText: _assetCreate.amount != -1
                  ? _assetCreate.amount.toString()
                  : null,
              textInputAction: TextInputAction.done,
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
            )
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
        return (investings.name + '/' + investings.symbol);
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
            tempList.add(Investings("American Dollar", "USD"));
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
        return (investings.name + '/' + investings.symbol);
      }
      return "";
    }
  );
}
