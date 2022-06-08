import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/check_dialog.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/content/models/responses/asset.dart';
import 'package:asset_flutter/content/providers/asset.dart';
import 'package:asset_flutter/content/providers/asset_details.dart';
import 'package:asset_flutter/content/providers/asset_logs.dart';
import 'package:asset_flutter/content/providers/portfolio/portfolio_state.dart';
import 'package:asset_flutter/content/widgets/portfolio/id_log_bottom_sheet.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:asset_flutter/content/widgets/portfolio/id_list_cell_text.dart';
import 'package:provider/provider.dart';

// ignore_for_file: prefer_const_constructors_in_immutables
class InvestmentDetailsListCell extends StatelessWidget {
  final AssetLog _data;
  late final AssetDetailsStateProvider _detailsStateProvider;
  late final AssetProvider _assetProvider;
  late final AssetLogProvider _assetLogProvider;

  InvestmentDetailsListCell(this._data, {Key? key}) : super(key: key);

  void _deleteAssetLog(BuildContext context) {
    _detailsStateProvider.setState(EditState.editing);

    Future.wait([
      _assetLogProvider.deleteAssetLog(_data.id, _data),
      _assetProvider.getAssetStats(
        toAsset: _data.toAsset, 
        fromAsset: _data.fromAsset,
        assetMarket: _data.market
      )
    ]).then((response){
      BaseAPIResponse _baseApiResponse = response.first as BaseAPIResponse;
      if (_baseApiResponse.error != null) {
        showDialog(
          context: context, 
          builder: (ctx) => ErrorDialog(_baseApiResponse.error!)
        );
      } else {
        if(_assetLogProvider.items.isEmpty) {
          Provider.of<PortfolioStateProvider>(context, listen: false).setRefresh(true);
          Navigator.pop(context);
          return;
        }
        _detailsStateProvider.setState(EditState.view);
      }
    });
  }

  void _editAssetLog(BuildContext context, String type, double amount, double price, bool isBought) {
    _detailsStateProvider.setState(EditState.editing);

    var isAmountChanged = _data.amount != amount;
    if (isAmountChanged) {
      _data.amount = amount;
    }

    if (_data.type != type) {
      _data.type = type;
    }
    
    if (_data.price != price) {
      _data.price = price;
    }

    _assetLogProvider.editAssetLog(_data, isAmountChanged).then((response) {
      try {
        if (response.error != null) {
          showDialog(
            context: context, 
            builder: (ctx) => ErrorDialog(response.error!)
          );
        } else {
          _assetProvider.getAssetStats(
            toAsset: _data.toAsset, 
            fromAsset: _data.fromAsset,
            assetMarket: _data.market
          ).whenComplete(() => _detailsStateProvider.setState(EditState.view));
        } 
      } catch (error) {
        _detailsStateProvider.setState(EditState.view);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _detailsStateProvider = Provider.of<AssetDetailsStateProvider>(context, listen: false);
    _assetProvider = Provider.of<AssetProvider>(context, listen: false);
    _assetLogProvider = Provider.of<AssetLogProvider>(context, listen: false);
    final _logBottomSheet = InvestmentDetailsLogBottomSheet(
      _data.toAsset, 
      _editAssetLog,
      isSell: _data.type == "sell",
      price: _data.price.toDouble(),
      amount: _data.amount.toDouble(),
    );

    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => showDialog(
              context: context,
              builder: (ctx) => AreYouSureDialog("edit", (){
                Navigator.pop(ctx);
                showModalBottomSheet(
                  context: ctx, 
                  isScrollControlled: true,
                  barrierColor: Colors.black54,
                  builder: (ctx) => _logBottomSheet
                );
              }),
            ),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            icon: Icons.edit_rounded,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) => showDialog(
              context: context,
              builder: (ctx) => AreYouSureDialog('delete', (){
                Navigator.pop(ctx);
                _deleteAssetLog(ctx);
              })
            ),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete_rounded,
            label: 'Delete',
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (layoutContext, constraints) {
          final slidable = Slidable.of(layoutContext);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topRight,
                  margin: const EdgeInsets.only(bottom: 12, left: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${_data.type[0].toUpperCase()}${_data.type.substring(1)}",
                        style: TextStyle(
                          color: _data.type == "buy" ? AppColors().greenColor : AppColors().redColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _data.createdAt.dateToDaysAgo(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
                InvestmentDetailsLogListCellText(
                  "Amount",
                  _data.amount.numToString(),
                ),
                InvestmentDetailsLogListCellText(
                  "Price",
                  _data.fromAsset.getCurrencyFromString() + ' ' +  _data.price.numToString(),
                ),
                Container(
                  width: double.infinity,
                  height: 10,
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(Icons.swipe_left_rounded, size: 14, color: AppColors().lightBlack),
                    onPressed: () {
                      if(slidable != null) {
                        if(slidable.direction.value == 0){
                          slidable.openEndActionPane();
                        }else {
                          slidable.close();
                        }
                      }
                    },
                  )
                )
              ],
            ),
          ); 
        },
      ),
    );
  }
}