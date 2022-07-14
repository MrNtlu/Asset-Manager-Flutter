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
import 'package:asset_flutter/content/widgets/portfolio/il_cell_image.dart';
import 'package:asset_flutter/static/images.dart';
import 'package:asset_flutter/utils/stock_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvestmentCreateDetailsPage extends StatefulWidget {
  final Investings _selectedItem;
  final Investings _selectedCurrencyItem;
  final String _investmentType;
  final String _investmentMarket;

  const InvestmentCreateDetailsPage(
    this._selectedItem, this._selectedCurrencyItem, 
    this._investmentType, this._investmentMarket, 
    {Key? key}
  ) : super(key: key);

  @override
  State<InvestmentCreateDetailsPage> createState() => _InvestmentCreateDetailsPageState();
}

class _InvestmentCreateDetailsPageState extends State<InvestmentCreateDetailsPage> {
  CreateState _state = CreateState.init;
  double? _price;

  final _form = GlobalKey<FormState>();
  late final AssetsProvider _assetsProvider;
  final bool isApple = Platform.isIOS || Platform.isMacOS;
  final AssetCreate _assetCreate = AssetCreate('', '', '', -1, '', '', '', -1);

  void _createAssetData() {
    _assetCreate.toAsset = widget._selectedItem.symbol;
    _assetCreate.name = widget._selectedItem.name;
    _assetCreate.fromAsset = widget._selectedCurrencyItem.symbol;
    _assetCreate.type = "buy";
    _assetCreate.assetType = widget._investmentType.toLowerCase();
    _assetCreate.assetMarket = widget._investmentMarket;
    _assetCreate.price = _price!;
  }

  void _createInvestment(BuildContext context) {
    if (_state == CreateState.editing) {
      setState(() {
        _state = CreateState.loading;
      });

      final _isValid = _form.currentState?.validate();
      if (_isValid != null && !_isValid && _price == null) {
        setState(() {
          _state = CreateState.editing;
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
                builder: (ctx) => ErrorDialog(value.error!.toString())
              );
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
      _assetsProvider = Provider.of<AssetsProvider>(context, listen: false);
      _state = CreateState.editing;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final String image;
    if (widget._investmentType == "Crypto") {
      image = PlaceholderImages().cryptoImage(widget._selectedItem.symbol);
    } else if (widget._investmentType == "Exchange") {
      image = PlaceholderImages().exchangeImage(widget._selectedItem.symbol);
    } else if (widget._investmentType == "Stock") {
      image = 'icons/flags/png/${convertIndexNameToFlag(widget._investmentMarket)}.png';
    } else {
      image = 'assets/images/gold.png';
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _state == CreateState.editing 
      ? AppBar(
        centerTitle: true,
        actions: const [
          IconButton(
            icon: Icon(Icons.save_rounded),
            iconSize: 0,
            onPressed: null,
          )
        ],
        title: InvestmentListCellImage(
          image,
          widget._investmentType.toLowerCase(), 
          size: 22,
          borderRadius: BorderRadius.circular(24),
          margin: const EdgeInsets.only(right: 8),
        ),
      )
      : null,
      body: SafeArea(
        child: _body(),
      ),
    );
  }

  Widget _body() {
    switch (_state) {
      case CreateState.success:
        return Container(color: Colors.black54, child: const SuccessView("created"));
      case CreateState.loading:
        return const LoadingView("Creating Investment");
      case CreateState.editing:
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 26, 16, 8),
          child: Form(
            key: _form,
            child: Column(
              children: [
                CustomTextFormField(
                  "Amount",
                  const TextInputType.numberWithOptions(decimal: true, signed: true),
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
                  const TextInputType.numberWithOptions(decimal: true, signed: true),
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
                          onPressed: () => _createInvestment(context),
                          child: const Text("Add Investment", style: TextStyle(color: Colors.white))
                        )
                        : ElevatedButton(
                          onPressed: () => _createInvestment(context),
                          child: const Text("Add Investment", style: TextStyle(color: Colors.white))
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      default:
        return const LoadingView("Loading");
    }
  }
}