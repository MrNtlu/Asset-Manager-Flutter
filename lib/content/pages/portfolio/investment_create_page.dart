import 'package:asset_flutter/common/widgets/dropdown.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/success_view.dart';
import 'package:asset_flutter/common/widgets/textformfield.dart';
import 'package:asset_flutter/content/models/requests/asset.dart';
import 'package:asset_flutter/content/models/responses/investings.dart';
import 'package:asset_flutter/content/providers/assets.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/currencies.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class InvestmentCreatePage extends StatefulWidget {
  const InvestmentCreatePage({Key? key}) : super(key: key);

  @override
  State<InvestmentCreatePage> createState() => _InvestmentCreatePageState();
}

//TODO On final step or first step make continue or cancel take action
// on final => continue can be removed or should ask do you want to save etc.
// on first => Cancel should ask do you want to go back
class _InvestmentCreatePageState extends State<InvestmentCreatePage> {
  final _form = GlobalKey<FormState>();
  final _investingsDropdownKey = GlobalKey<DropdownSearchState<String>>();
  late final AssetsProvider _assetsProvider;

  final AssetCreate _assetCreate = AssetCreate('', '', '', -1, '', '');
  late final List<Investings> _investingList = [];
  final List<bool> _isSelected = [true, false];
  Investings? _selectedItem;
  double? _price;

  late final Dropdown _investmentDropdown;
  late final Dropdown _currencyDropdown;
  late final DropdownSearch _investingsDropdown;

  bool _isInit = false;
  bool _isLoading = false;
  int _currentStep = 0;

  void _createAssetData() {
    _assetCreate.toAsset = _selectedItem!.symbol;
    _assetCreate.name = _selectedItem!.name;
    _assetCreate.fromAsset = _currencyDropdown.dropdownValue.toUpperCase();
    _assetCreate.type = _isSelected[0] ? "buy" : "sell";
    _assetCreate.assetType = _investmentDropdown.dropdownValue.toLowerCase();
    if (_isSelected[0]) {
      _assetCreate.boughtPrice = _price;
    } else {
      _assetCreate.soldPrice = _price;
    }
  }

  void _createInvestment(BuildContext context) {
    if (_selectedItem == null) {
      setState(() {
        _currentStep = 1;
      });
      showDialog(
          context: context,
          builder: (ctx) => const ErrorDialog("Please select investment."));
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
      _isLoading = true;
    });

    _form.currentState?.save();
    _createAssetData();

    _assetsProvider.createAsset(_assetCreate).then((value) {
      setState(() {
        _isLoading = false;
      });
      if (value.error == null) {
        showDialog(
          barrierColor: Colors.black87,
          context: context,
          barrierDismissible: false,
          builder: (ctx) => const SuccessView("created")
        );
      } else {
        showDialog(
            context: context, builder: (ctx) => ErrorDialog(value.error!));
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _investmentDropdown = _createInvestmentDropdown();
      _investingsDropdown = _createInvestingsDropdown();
      _currencyDropdown = _createCurrencyDropdown();
      _assetsProvider = Provider.of<AssetsProvider>(context, listen: false);
    }
    _isInit = true;
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
      body: SafeArea(
        child: _isLoading
            ? const LoadingView("Creating Investment")
            : Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 8, bottom: 12),
                    child: _createToggleButtons(),
                  ),
                  Expanded(
                    child: Stepper(
                      type: StepperType.horizontal,
                      onStepTapped: (index) {
                        if (_currentStep == 1 && index != _currentStep) {
                          _investingList.clear();
                        }
                        if (index == 0) {
                          _selectedItem = null;
                        }

                        if (_currentStep == 1 &&
                            _selectedItem == null &&
                            index != 0) {
                          showDialog(
                              context: context,
                              builder: (ctx) => const ErrorDialog(
                                  "Please select investment."));
                        } else {
                          setState(() {
                            _currentStep = index;
                          });
                        }
                      },
                      steps: getSteps(),
                      currentStep: _currentStep,
                      onStepContinue: () {
                        if (!(getSteps().length - 1 == _currentStep)) {
                          setState(() {
                            _currentStep += 1;
                          });
                        }
                      },
                      onStepCancel: () {
                        if (_currentStep == 1) {
                          _investingList.clear();
                        }
                        if (_currentStep == 1 && _selectedItem == null) {
                          showDialog(
                              context: context,
                              builder: (ctx) => const ErrorDialog(
                                  "Please select investment."));
                        } else if (_currentStep != 0) {
                          setState(() {
                            _currentStep -= 1;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // Stepper
  // https://www.youtube.com/watch?v=MpQTNW5woVI
  List<Step> getSteps() => [
        Step(
            isActive: _currentStep >= 0,
            title: const Text("Type"),
            content: _investmentDropdown),
        Step(
            isActive: _currentStep >= 1,
            title: const Text("Pick"),
            content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  _investingsDropdown,
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Currency",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _currencyDropdown
                      ],
                    ),
                  )
                ],
              ),
            )),
        Step(
            isActive: _currentStep >= 2,
            title: const Text("Details"),
            content: Form(
              key: _form,
              child: Column(
                children: [
                  CustomTextFormField(
                    "Buy/Sell Price",
                    const TextInputType.numberWithOptions(decimal: true),
                    initialText: _price != null ? _price.toString() : null,
                    textInputAction: TextInputAction.next,
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
                    const TextInputType.numberWithOptions(decimal: true),
                    initialText: _assetCreate.amount != -1
                        ? _assetCreate.amount.toString()
                        : null,
                    textInputAction: TextInputAction.done,
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
            ))
      ];

  ToggleButtons _createToggleButtons() => ToggleButtons(
        color: Colors.black,
        selectedColor: Colors.white,
        fillColor: _isSelected[0] ? Colors.green : Colors.red,
        children: const [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text("Buy", style: TextStyle(fontSize: 16))),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text("Sell", style: TextStyle(fontSize: 16))),
        ],
        isSelected: _isSelected,
        onPressed: (int newIndex) {
          setState(() {
            var falseIndex = newIndex == 0 ? 1 : 0;
            if (!_isSelected[newIndex]) {
              _isSelected[newIndex] = true;
              _isSelected[falseIndex] = false;
            }
          });
        },
      );

  Dropdown _createCurrencyDropdown() => Dropdown(
        SupportedCurrencies().currencies,
      );

  Dropdown _createInvestmentDropdown() => Dropdown(
        const ["Crypto", "Stock", "Exchange"],
        dropdownValue: "Crypto",
        isExpanded: true,
        textStyle: const TextStyle(fontSize: 16, color: Colors.black),
      );

  DropdownSearch _createInvestingsDropdown() => DropdownSearch<Investings>(
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
                  "?type=${_investmentDropdown.dropdownValue.toLowerCase()}"),
            );
            _investingList
                .addAll(response.getBaseListResponse<Investings>().data);
          }
          return _investingList;
        },
        onChanged: (Investings? investings) => _selectedItem = investings,
        itemAsString: (Investings? investings) => investings != null
            ? (investings.name + '/' + investings.symbol)
            : "",
      );
}
