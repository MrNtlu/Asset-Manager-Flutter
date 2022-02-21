import 'dart:math';

import 'package:asset_flutter/common/widgets/add_elevated_button.dart';
import 'package:asset_flutter/content/models/requests/asset.dart';
import 'package:asset_flutter/content/models/responses/asset.dart';
import 'package:asset_flutter/content/providers/asset_logs.dart';
import 'package:asset_flutter/content/widgets/portfolio/id_log_list.dart';
import 'package:asset_flutter/content/widgets/portfolio/id_top_bar.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvestmentDetailsPage extends StatelessWidget {
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
            InvestmentDetailsLogList(appBar.preferredSize.height, _data),
            InvestmentDetailsTopBar(_data, image),
            Container(
              alignment: Alignment.bottomCenter,
              child: AddElevatedButton(('Add ' + _data.toAsset), () {
                Provider.of<AssetLogProvider>(context, listen: false).addAssetLog(
                  AssetCreate(_data.toAsset, _data.fromAsset, "buy", 0.1, _data.type, _data.name, boughtPrice: 44105.21)
                );
                print('Add ' + _data.toAsset + ' ' + _data.type);
              },
              edgeInsets: const EdgeInsets.only(left: 8, right: 8, bottom: 8)),
            )
          ],
        ),
      ),
    );
  }
}
