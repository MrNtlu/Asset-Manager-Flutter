import 'package:asset_flutter/content/models/responses/asset.dart';
import 'package:asset_flutter/content/widgets/portfolio/id_list_cell.dart';
import 'package:flutter/material.dart';

class InvestmentDetailsLogList extends StatelessWidget {
  final double _appBarHeight;
  final List<AssetLog> assetLogs;

  const InvestmentDetailsLogList(this._appBarHeight, this.assetLogs, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - ( 
        _appBarHeight + 
        MediaQuery.of(context).padding.top + 
        MediaQuery.of(context).padding.bottom),
      child: ListView.builder(
        itemBuilder: (context, index) {
          if (index == 0) {
            return const SizedBox(height: 100);
          } else if (index == assetLogs.length + 1){
            return const SizedBox(height: 65);
          }

          final data = assetLogs[index - 1];

          return InvestmentDetailsListCell(data);
        },
        itemCount: assetLogs.length + 2,
        padding: const EdgeInsets.only(top: 4),
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }
}