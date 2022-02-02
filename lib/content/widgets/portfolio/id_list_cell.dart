import 'package:asset_flutter/content/pages/portfolio/portfolio_page.dart';
import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:asset_flutter/content/widgets/portfolio/id_list_cell_text.dart';

class InvestmentDetailsListCell extends StatelessWidget {
  final TestInvestLogData _data;

  const InvestmentDetailsListCell(this._data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 8, right: 4, left: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: _data.type == "buy" ? TabsPage.primaryLightColor : Colors.red.shade600,
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

              },
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              icon: Icons.edit_rounded,
              label: 'Change',
            ),
            SlidableAction(
              onPressed: (context) {
                
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