import 'package:asset_flutter/common/widgets/add_elevated_button.dart';
import 'package:asset_flutter/content/models/responses/asset.dart';
import 'package:asset_flutter/content/pages/portfolio/investment_log_create_page.dart';
import 'package:asset_flutter/content/widgets/portfolio/id_log_list.dart';
import 'package:asset_flutter/content/widgets/portfolio/id_top_bar.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/images.dart';
import 'package:flutter/material.dart';

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
            InvestmentDetailsLogList(appBar.preferredSize.height, _data),
            InvestmentDetailsTopBar(_data, image),
            Container(
              alignment: Alignment.bottomCenter,
              child: AddElevatedButton(('Add ' + _data.toAsset), () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: ((context) => InvestmentLogCreatePage()))
                );
              },
              edgeInsets: const EdgeInsets.only(left: 8, right: 8, bottom: 8)),
            )
          ],
        ),
      ),
    );
  }
}
