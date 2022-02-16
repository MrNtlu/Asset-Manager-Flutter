import 'package:asset_flutter/common/widgets/dropdown.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/content/models/responses/investings.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/currencies.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InvestmentCreatePage extends StatefulWidget {
  const InvestmentCreatePage({Key? key}) : super(key: key);

  @override
  State<InvestmentCreatePage> createState() => _InvestmentCreatePageState();
}

class _InvestmentCreatePageState extends State<InvestmentCreatePage> {
  final _investingsDropdownKey = GlobalKey<DropdownSearchState<String>>();
  late final Dropdown _investmentDropdown;
  late final DropdownSearch _investingsDropdown;
  late final List<Investings> _investingList = [];
  Investings? _selectedItem;

  final List<bool> _isSelected = [true, false];
  bool _isInit = false;
  bool _isLoading = false;
  int _currentStep = 0;

  void _createInvestment(BuildContext context) {
    //if is valid
    print(_selectedItem);
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _investmentDropdown = Dropdown(
        const ["Crypto", "Stock", "Exchange"], 
        dropdownValue: "Crypto",
        isExpanded: true,
        textStyle: const TextStyle(
          fontSize: 16,
          color: Colors.black
        ),
      );

      _investingsDropdown = DropdownSearch<Investings>(
        key: _investingsDropdownKey,
        showSearchBox: true,
        dropdownSearchDecoration: const InputDecoration(
          label: Text('Investment')
        ),
        showClearButton: true,
        onFind: (String? _) async {
          if(_investingList.isEmpty){
            var response = await http.get(
              Uri.parse(APIRoutes().assetRoutes.investingsByType + "?type=${_investmentDropdown.dropdownValue.toLowerCase()}"),
            );
            _investingList.addAll(response.getBaseListResponse<Investings>().data);
          }
          return _investingList;
        },
        onChanged: (Investings? investings){
          _selectedItem = investings;
        },
        itemAsString: (Investings? investings) => investings != null ? (investings.name + '/' + investings.symbol) : "",
      );
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
            ? const LoadingView("Creating Investment...")
            : Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 8, bottom: 12),
                  child: ToggleButtons(
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
                  ),
                ),
                Expanded(
                  child: Stepper(
                    type: StepperType.horizontal,
                    onStepTapped: (index) { 
                      if (_currentStep == 1) {
                        _investingList.clear();
                      }
                      if (_currentStep == 1 && _selectedItem == null) {
                        showDialog(
                          context: context, 
                          builder: (ctx) => const ErrorDialog("Please select investment.")
                        );
                      }else {
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
                          builder: (ctx) => const ErrorDialog("Please select investment.")
                        );
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Currency",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Dropdown(
                    SupportedCurrencies().currencies,
                  )
                ],
              )
            ],
          ),
        )),
    Step(
        isActive: _currentStep >= 2,
        title: const Text("Details"),
        content: Container())
  ];
}
