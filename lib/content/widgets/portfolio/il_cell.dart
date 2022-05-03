import 'package:asset_flutter/content/pages/portfolio/investment_details_page.dart';
import 'package:asset_flutter/content/providers/asset.dart';
import 'package:asset_flutter/content/widgets/portfolio/il_cell_image.dart';
import 'package:asset_flutter/content/widgets/portfolio/pl_text.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/images.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:asset_flutter/utils/stock_handler.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class PortfolioInvestmentListCell extends StatelessWidget {
  late final Asset data;
  late final String image;

  PortfolioInvestmentListCell(this.data) {
    if (data.type == "crypto") {
      image = PlaceholderImages().cryptoImage(data.toAsset);
    } else if (data.type == "exchange") {
      image = PlaceholderImages().exchangeImage(data.toAsset);
    } else if (data.type == "stock") {
      image = 'icons/flags/png/${convertIndexNameToFlag(data.market)}.png';
    } else {
      image = 'assets/images/gold.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: ((context) => InvestmentDetailsPage(data))));
      },
      title: Row(
        children: [
          InvestmentListCellImage(
            image, 
            data.type, 
            size: 22,
            margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              child: AutoSizeText(
                data.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                maxFontSize: 18,
                minFontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 6),
                  child: AutoSizeText(
                    data.currentValue.numToString() + ' ' + data.fromAsset,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                    maxFontSize: 16,
                    minFontSize: 14,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(right: 6, top: 4),
                  child: PortfolioPLText(
                    data.pl.toDouble(), 
                    null,
                    null,
                    fontSize: 13,
                    iconSize: 15,
                    plPrefix: data.fromAsset
                  )
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: data.pl.abs() <= 0.01
              ? Colors.grey
              : (data.pl < 0 ? AppColors().greenColor : AppColors().redColor),
              borderRadius: const BorderRadius.all(Radius.circular(6)),
            ),
            width: 60,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
            margin: const EdgeInsets.only(left: 2),
            child: AutoSizeText(
              data.pl.abs() <= 0.01
              ? '' : (data.pl < 0 ? '+' : '-') +
              "${data.plPercentage.abs().toStringAsFixed(1)}%", 
              style: const TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              maxFontSize: 13,
              minFontSize: 11,
            ),
          )
        ],
      ),
    );
  }
}
