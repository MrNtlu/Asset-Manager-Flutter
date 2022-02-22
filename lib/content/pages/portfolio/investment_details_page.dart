import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/add_elevated_button.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/success_view.dart';
import 'package:asset_flutter/common/widgets/textformfield.dart';
import 'package:asset_flutter/content/models/responses/asset.dart';
import 'package:asset_flutter/content/providers/asset.dart';
import 'package:asset_flutter/content/providers/assets.dart';
import 'package:asset_flutter/content/widgets/portfolio/id_log_list.dart';
import 'package:asset_flutter/content/widgets/portfolio/id_top_bar.dart';
import 'package:asset_flutter/content/widgets/portfolio/investment_toggle_button.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asset_flutter/content/providers/asset_logs.dart';
import 'package:asset_flutter/content/models/requests/asset.dart';

class InvestmentDetailsPage extends StatefulWidget {
  final Asset _data;
  late final String image;

  InvestmentDetailsPage(this._data) {
    if (_data.type == "crypto") {
      image = PlaceholderImages().cryptoImage(_data.toAsset);
    } else if (_data.type == "exchange") {
      image = PlaceholderImages().exchangeImage(_data.toAsset);
    } else {
      image = PlaceholderImages().stockImage(_data.toAsset);
    }
  }

  @override
  State<InvestmentDetailsPage> createState() => _InvestmentDetailsPageState();
}

//TODO: On init get stats

class _InvestmentDetailsPageState extends State<InvestmentDetailsPage> {
  EditState _state = EditState.init;
  late final AppBar _appBar;
  late final AssetProvider _data;

  void _createInvestmentLog(BuildContext context, String type, double amount, double price, bool isBought) {
    setState(() {
      _state = EditState.loading;
    });
    Provider.of<AssetLogProvider>(context, listen: false).addAssetLog(
      AssetCreate(
        _data.asset!.toAsset, 
        _data.asset!.fromAsset, 
        type, 
        amount, 
        _data.asset!.type, 
        _data.asset!.name, 
        boughtPrice: isBought ? price : null,
        soldPrice: isBought ? null : price
      )
    ).then((response) {
      if (_state != EditState.disposed) {
        if (response.error != null) {
          showDialog(
            context: context, 
            builder: (ctx) => ErrorDialog(response.error!)
          );
        }

        Provider.of<AssetProvider>(context, listen: false).getAssetStats(
          toAsset: _data.asset!.toAsset, 
          fromAsset: _data.asset!.fromAsset
        ).then((response) {
          if (_state != EditState.disposed) {
            setState(() {
              _state = EditState.view;
            });
            showDialog(
              context: context, 
              builder: (ctx) => const SuccessView("added", shouldJustPop: true)
            ); 
          }
        });
      }
    });
  }

  void _openAddInvestmentLogBottomSheet(BuildContext context, {AssetLog? assetLog, bool isEditing = false}) {
    double _price = -1;
    double _amount = -1;
    final InvestmentToggleButton _toggleButton = InvestmentToggleButton();
    final _form = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context, 
      barrierColor: Colors.black54,
      isDismissible: false,
      builder: (ctx) {
        return Container(
          height: 340,
          margin: const EdgeInsets.all(12),
          child: Form(
            key: _form,
            child: Column(
              children: [
                _toggleButton,
                CustomTextFormField(
                  "Buy/Sell Price",
                  const TextInputType.numberWithOptions(decimal: true),
                  //initialText: isEditing ? _price.toString() : null,
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
                  // initialText: _assetCreate.amount != -1
                  //     ? _assetCreate.amount.toString()
                  //     : null,
                  textInputAction: TextInputAction.done,
                  onSaved: (value) {
                    if (value != null) {
                      _amount = double.parse(value);
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        }, 
                        child: const Text("Cancel", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final _isValid = _form.currentState?.validate();
                          if (_isValid != null && !_isValid) {
                            return;
                          }

                          _form.currentState?.save();
                          Navigator.pop(context);
                          _createInvestmentLog(context, (_toggleButton.isSelected[0] ? "buy" : "sell"), _amount, _price, _toggleButton.isSelected[0]);
                        }, 
                        child: Text("Add ${widget._data.toAsset}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }

  @override
  void dispose() {
    _state = EditState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == EditState.init) {
      _data = Provider.of<AssetProvider>(context);
      _data.asset = widget._data;

      _appBar = AppBar(
        title: Text(_data.asset!.name),
        backgroundColor: AppColors().primaryLightishColor,
      );
    }

    _state = EditState.view;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar,
      body: SafeArea(
        child: _body(),
      ),
    );
  }

  Widget _body() {
    switch (_state) {
      case EditState.view:
        return Stack(
          children: [
            InvestmentDetailsLogList(_appBar.preferredSize.height, _data.asset!),
            InvestmentDetailsTopBar(_data.asset!, widget.image),
            Container(
              alignment: Alignment.bottomCenter,
              child: AddElevatedButton(('Add ' + widget._data.toAsset), () {
                _openAddInvestmentLogBottomSheet(context);
              },
              edgeInsets: const EdgeInsets.only(left: 8, right: 8, bottom: 8)),
            )
          ],
        );
      case EditState.loading:
        return const LoadingView("Adding");
      default:
        return const LoadingView("Loading");
    }
  }
}
