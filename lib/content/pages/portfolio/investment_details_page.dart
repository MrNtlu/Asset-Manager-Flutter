import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/add_elevated_button.dart';
import 'package:asset_flutter/common/widgets/check_dialog.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/content/providers/asset.dart';
import 'package:asset_flutter/content/providers/asset_details.dart';
import 'package:asset_flutter/content/providers/portfolio/portfolio_state.dart';
import 'package:asset_flutter/content/widgets/portfolio/id_log_bottom_sheet.dart';
import 'package:asset_flutter/content/widgets/portfolio/id_log_list.dart';
import 'package:asset_flutter/content/widgets/portfolio/id_top_bar.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asset_flutter/content/providers/asset_logs.dart';
import 'package:asset_flutter/content/models/requests/asset.dart';
import 'package:asset_flutter/utils/stock_handler.dart';

class InvestmentDetailsPage extends StatefulWidget {
  final Asset _data;
  late final String image;

  InvestmentDetailsPage(this._data) {
    if (_data.type == "crypto") {
      image = PlaceholderImages().cryptoImage(_data.toAsset);
    } else if (_data.type == "exchange") {
      image = PlaceholderImages().exchangeImage(_data.toAsset);
    } else if (_data.type == "stock") {
      image = 'icons/flags/png/${convertIndexNameToFlag(_data.market)}.png';
    } else {
      image = 'assets/images/gold.png';
    }
  }

  @override
  State<InvestmentDetailsPage> createState() => _InvestmentDetailsPageState();
}

class _InvestmentDetailsPageState extends State<InvestmentDetailsPage> {
  EditState _state = EditState.init;
  late final AppBar _appBar;
  late final AssetProvider _assetProvider;
  late final AssetDetailsStateProvider _stateListener;
  bool isDataChanged = false;

  void _getStats() {
    Provider.of<AssetProvider>(context, listen: false).getAssetStats(
      toAsset: widget._data.toAsset, 
      fromAsset: widget._data.fromAsset,
      assetMarket: widget._data.market
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
        _assetProvider.asset!.market,
        _assetProvider.asset!.name, 
        price,
      )
    ).then((response) {
      if (_state != EditState.disposed) {
        if (response.error != null) {
          showDialog(
            context: context, 
            builder: (ctx) => ErrorDialog(response.error!)
          );
        }
        isDataChanged = true;

        _getStats();
      }
    });
  }

  Widget _deleteDialog(BuildContext context) => AreYouSureDialog("delete investment", (){
    Navigator.pop(context);
    setState(() {
      _state = EditState.editing;
    });
    
    Provider.of<AssetLogProvider>(context, listen: false)
      .deleteAllAssetLogs(widget._data.toAsset, widget._data.fromAsset, widget._data.market)
      .then((response){
        if (_state != EditState.disposed) {
          if (response.error != null) {
            setState(() {
              _state = EditState.view;
            });
            showDialog(
              context: context, 
              builder: (ctx) => ErrorDialog(response.error!)
            );
          } else {
            isDataChanged = true;
            Navigator.maybePop(context);
          } 
        }
    });
  });

  void _deleteLogs(BuildContext context) {
    Platform.isMacOS || Platform.isIOS
    ? showCupertinoDialog(
      context: context, 
      builder: (_) => _deleteDialog(context)
    )
    : showDialog(
      context: context, 
      builder: (_) => _deleteDialog(context)
    );
  }

  void _assetDetailsStateListener() {
    if (_state != EditState.disposed) {
      if (_state == EditState.editing) {
        isDataChanged = true;
        _getStats();
      } else {
        setState(() {
          _state = _stateListener.state;
        });
      }
    }
  }

  @override
  void dispose() {
    _stateListener.removeListener(_assetDetailsStateListener);
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
        actions: [
          IconButton(
            onPressed: () => _deleteLogs(context), 
            icon: const Icon(Icons.delete_rounded),
            tooltip: "Delete Investment",
          ),
        ],
      );

      _stateListener = Provider.of<AssetDetailsStateProvider>(context);
      _stateListener.addListener(_assetDetailsStateListener);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isDataChanged) {
          Provider.of<PortfolioStateProvider>(context, listen: false).setRefresh(true);
        }
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _appBar,
        body: SafeArea(
          child: _body(),
        ),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: AddElevatedButton(('Add ' + widget._data.toAsset), () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  barrierColor: Colors.black54,
                  builder: (ctx) => InvestmentDetailsLogBottomSheet(
                    widget._data.toAsset, 
                    _createInvestmentLog
                  )
                );
              },
              edgeInsets: const EdgeInsets.only(left: 8, right: 6, bottom: 8)),
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
