import 'dart:math';

import 'package:asset_flutter/common/widgets/add_elevated_button.dart';
import 'package:asset_flutter/content/models/responses/asset.dart';
import 'package:asset_flutter/content/pages/portfolio/portfolio_page.dart';
import 'package:asset_flutter/content/providers/asset_logs.dart';
import 'package:asset_flutter/content/widgets/portfolio/id_log_list.dart';
import 'package:asset_flutter/content/widgets/portfolio/id_top_bar.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvestmentDetailsPage extends StatelessWidget {
  final Asset _data;
  late final String image;

  InvestmentDetailsPage(this._data) {
    if (_data.type == "crypto") {
      image = TestData.cryptoImage(_data.toAsset);
    } else {
      image = TestData.stockImage(_data.toAsset);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppBar appBar = AppBar(
      title: Text(_data.name),
      backgroundColor: AppColors().primaryLightishColor,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: SafeArea(
        child: Stack(
          children: [
            //TODO: Pagination
            //TODO: https://www.youtube.com/c/JohannesMilke/search?query=pagination
            InvestmentDetailsLogList(appBar.preferredSize.height, Provider.of<AssetLogProvider>(context).items),
            InvestmentDetailsTopBar(_data, image),
            Container(
              alignment: Alignment.bottomCenter,
              child: AddElevatedButton(('Add ' + _data.toAsset), () {
                Provider.of<AssetLogProvider>(context, listen: false).addAssetLog(AssetLog(Random().toString(), 100, "BTC", "USD", "buy", 0.1, DateTime.now(), boughtPrice: 44105.21));
                print('Add ' + _data.toAsset);
              },
              edgeInsets: const EdgeInsets.only(left: 8, right: 8, bottom: 8)),
            )
          ],
        ),
      ),
    );
  }
}
