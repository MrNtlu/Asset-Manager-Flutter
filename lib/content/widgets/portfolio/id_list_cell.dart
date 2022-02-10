import 'package:asset_flutter/content/models/responses/asset.dart';
import 'package:asset_flutter/content/providers/assets.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:asset_flutter/content/widgets/portfolio/id_list_cell_text.dart';
import 'package:provider/provider.dart';

class InvestmentDetailsListCell extends StatelessWidget {
  final AssetLog _data;

  const InvestmentDetailsListCell(this._data, {Key? key}) : super(key: key);

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
                Provider.of<AssetLogs>(context, listen: false).editAssetLog(_data);
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
                  builder: (ctx) {
                    return AlertDialog(
                      title: const Text('Are you sure?'),
                      content: const Text('Do you want to delete?'),
                      actions: [
                        TextButton(
                          onPressed: (){
                            Navigator.pop(ctx);
                          },
                          child: const Text('NO')
                        ),
                        TextButton(
                          onPressed: (){
                            Provider.of<AssetLogs>(ctx, listen: false).deleteAssetLog(_data.id);
                            Navigator.pop(ctx);
                          },
                          child: const Text('Yes')
                        )
                      ],
                    );
                  }
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
                _data.type == "buy" ? "Bought Price" : "Sold Price",
                _data.type == "buy" ? _data.boughtPrice.toString() : _data.soldPrice.toString(),
              ),
              InvestmentDetailsLogListCellText(
                "Amount in "+_data.fromAsset,
                _data.amount.toString(),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8),
                alignment: Alignment.center,
                child: Text(
                  _data.value.toString() + ' ' + _data.fromAsset,
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