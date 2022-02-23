import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/add_elevated_button.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/success_view.dart';
import 'package:asset_flutter/content/providers/asset.dart';
import 'package:asset_flutter/content/providers/asset_details.dart';
import 'package:asset_flutter/content/widgets/portfolio/id_log_bottom_sheet.dart';
import 'package:asset_flutter/content/widgets/portfolio/id_log_list.dart';
import 'package:asset_flutter/content/widgets/portfolio/id_top_bar.dart';
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

class _InvestmentDetailsPageState extends State<InvestmentDetailsPage> {
  EditState _state = EditState.init;
  late final AppBar _appBar;
  late final AssetProvider _assetProvider;

  void _getStats() {
    Provider.of<AssetProvider>(context, listen: false).getAssetStats(
      toAsset: widget._data.toAsset, 
      fromAsset: widget._data.fromAsset
    ).then((response) {
      if (_state != EditState.disposed) {
        if (_state == EditState.init) {
          if (response.data == null) { 
            _assetProvider.asset = widget._data;
          }

          setState(() {
            _state = EditState.view;
          });
        } else {
          setState(() {
            _state = EditState.view;
          });
          showDialog(
            context: context, 
            builder: (ctx) => const SuccessView("added", shouldJustPop: true)
          ); 
        }
      }
    });
  }

  void _createInvestmentLog(BuildContext context, String type, double amount, double price, bool isBought) {
    setState(() {
      _state = EditState.loading;
    });
    Provider.of<AssetLogProvider>(context, listen: false).addAssetLog(
      AssetCreate(
        _assetProvider.asset!.toAsset, 
        _assetProvider.asset!.fromAsset, 
        type, 
        amount, 
        _assetProvider.asset!.type, 
        _assetProvider.asset!.name, 
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

        _getStats();
      }
    });
  }

  @override
  void dispose() {
    _state = EditState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == EditState.init) {
      _assetProvider = Provider.of<AssetProvider>(context);
      _getStats();

      _appBar = AppBar(
        title: Text(widget._data.name),
        backgroundColor: AppColors().primaryLightishColor,
      );

      var _stateListener = Provider.of<AssetDetailsStateProvider>(context);
      _stateListener.addListener(() {
        if (_state != EditState.disposed) {
          setState(() {
            _state = _stateListener.state;
          });
        }
      });
    }
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
            InvestmentDetailsLogList(_appBar.preferredSize.height, _assetProvider.asset!),
            InvestmentDetailsTopBar(_assetProvider.asset!, widget.image),
            Container(
              alignment: Alignment.bottomCenter,
              child: AddElevatedButton(('Add ' + widget._data.toAsset), () {
                showModalBottomSheet(
                  context: context, 
                  barrierColor: Colors.black54,
                  isDismissible: false,
                  builder: (ctx) {
                    return InvestmentDetailsLogBottomSheet(
                      widget._data.toAsset, 
                      _createInvestmentLog
                    );
                  }
                );
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
