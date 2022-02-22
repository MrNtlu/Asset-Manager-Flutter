import 'package:asset_flutter/common/widgets/check_dialog.dart';
import 'package:asset_flutter/content/models/responses/asset.dart';
import 'package:asset_flutter/content/providers/asset.dart';
import 'package:asset_flutter/content/providers/asset_logs.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:asset_flutter/content/widgets/portfolio/id_list_cell_text.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/error_dialog.dart';

class InvestmentDetailsListCell extends StatelessWidget {
  final AssetLog _data;

  const InvestmentDetailsListCell(this._data, {Key? key}) : super(key: key);

  void _deleteAssetLog(BuildContext ctx) {
    Provider.of<AssetLogProvider>(ctx, listen: false).deleteAssetLog(_data.id).then((response){
      if (response.error != null) {
        showDialog(
            context: ctx, 
            builder: (ctx) => ErrorDialog(response.error!)
          );
      } else {
        Provider.of<AssetProvider>(ctx, listen: false).getAssetStats(
          toAsset: _data.toAsset, 
          fromAsset: _data.fromAsset
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: (context) {
                _data.value = 1200;
                Provider.of<AssetLogProvider>(context, listen: false).editAssetLog(_data);
              },
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              icon: Icons.edit_rounded,
              label: 'Change',
            ),
            SlidableAction(
              onPressed: (context) {
                showDialog(
                  context: context,
                  builder: (ctx) => AreYouSureDialog('delete', (){
                      Navigator.pop(ctx);
                      _deleteAssetLog(ctx);
                    }
                  )
                );
              },
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