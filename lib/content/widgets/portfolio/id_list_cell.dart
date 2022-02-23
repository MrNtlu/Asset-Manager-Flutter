import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/check_dialog.dart';
import 'package:asset_flutter/content/models/responses/asset.dart';
import 'package:asset_flutter/content/providers/asset.dart';
import 'package:asset_flutter/content/providers/asset_details.dart';
import 'package:asset_flutter/content/providers/asset_logs.dart';
import 'package:asset_flutter/content/widgets/portfolio/id_log_bottom_sheet.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:asset_flutter/content/widgets/portfolio/id_list_cell_text.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/error_dialog.dart';

class InvestmentDetailsListCell extends StatelessWidget {
  final AssetLog _data;
  late final AssetDetailsStateProvider _provider;

  InvestmentDetailsListCell(this._data, {Key? key}) : super(key: key);

  void _deleteAssetLog(BuildContext context) {
    Provider.of<AssetDetailsStateProvider>(context, listen: false).setState(EditState.loading);

    Future.wait([
      Provider.of<AssetLogProvider>(context, listen: false).deleteAssetLog(_data.id),
      Provider.of<AssetProvider>(context, listen: false).getAssetStats(
        toAsset: _data.toAsset, 
        fromAsset: _data.fromAsset
      )
    ]).then((response){
      BaseAPIResponse _baseApiResponse = response.first as BaseAPIResponse;
      if (_baseApiResponse.error != null) {
        showDialog(
          context: context, 
          builder: (ctx) => ErrorDialog(_baseApiResponse.error!)
        );
      } else {
         _provider.setState(EditState.view);
      }
    });
  }

  void _editAssetLog(BuildContext context, String type, double amount, double price, bool isBought) {
    Provider.of<AssetDetailsStateProvider>(context, listen: false).setState(EditState.loading);

    var isAmountChanged = _data.amount != amount;
    if (isAmountChanged) {
      _data.amount = amount;
    }

    if (_data.type != type) {
      if (type == "buy") {
        _data.soldPrice = null;
        _data.boughtPrice = price;
      } else {
        _data.boughtPrice = null;
        _data.soldPrice = price;
      }
      _data.type = type;
    } else if (_data.type == "buy" && _data.boughtPrice != price) {
      _data.boughtPrice = price;
    } else if (_data.type == "sell" && _data.soldPrice != price) {
      _data.soldPrice = price;
    }

    Future.wait([
      Provider.of<AssetLogProvider>(context, listen: false).editAssetLog(_data, isAmountChanged),
      Provider.of<AssetProvider>(context, listen: false).getAssetStats(
        toAsset: _data.toAsset, 
        fromAsset: _data.fromAsset
      )
    ]).then((response){
      BaseAPIResponse _baseApiResponse = response.first as BaseAPIResponse;
      if (_baseApiResponse.error != null) {
        showDialog(
          context: context, 
          builder: (ctx) => ErrorDialog(_baseApiResponse.error!)
        );
      } else {
         _provider.setState(EditState.view);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<AssetDetailsStateProvider>(context, listen: false);
    return Card(
      margin: const EdgeInsets.only(top: 8, right: 4, left: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: _data.type == "buy" ? AppColors().primaryLightColor : Colors.red.shade600,
          width: 1
        )
      ),
      color: Colors.white,
      child: Slidable(
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
                    barrierColor: Colors.black54,
                    isDismissible: false,
                    builder: (ctx) {
                      return InvestmentDetailsLogBottomSheet(
                        _data.toAsset, 
                        _editAssetLog,
                        isSell: _data.type == "sell",
                        price: (_data.boughtPrice ?? _data.soldPrice)!.toDouble(),
                        amount: _data.amount.toDouble(),
                      );
                    }
                  );
                }),
              ),
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              icon: Icons.edit_rounded,
              label: 'Change',
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
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topRight,
                margin: const EdgeInsets.only(bottom: 12),
                child: Text(
                  _data.createdAt.dateToDaysAgo(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              InvestmentDetailsLogListCellText(
                (_data.type == "buy" ? "Bought Price in " : "Sold Price in ") + _data.fromAsset,
                _data.type == "buy" ? _data.boughtPrice!.numToString() : _data.soldPrice!.numToString(),
              ),
              InvestmentDetailsLogListCellText(
                "Amount",
                _data.amount.numToString(),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                alignment: Alignment.center,
                child: Text(
                  _data.value.numToString() + ' ' + _data.fromAsset,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}