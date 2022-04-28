import 'package:asset_flutter/content/pages/portfolio/investment_details_page.dart';
import 'package:asset_flutter/content/providers/asset.dart';
import 'package:asset_flutter/content/widgets/portfolio/il_cell_image.dart';
import 'package:asset_flutter/content/widgets/portfolio/pl_text.dart';
import 'package:asset_flutter/static/images.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:asset_flutter/utils/stock_handler.dart';
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
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
              MaterialPageRoute(builder: ((context) => InvestmentDetailsPage(data))));
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        color: Colors.white,
        margin: const EdgeInsets.only(left: 8, bottom: 8, right: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            InvestmentListCellImage(image, data.type),
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: Text(
                data.toAsset,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      data.currentValue.numToString() + ' ' + data.fromAsset,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 12, top: 4),
                    child: PortfolioPLText(
                      data.pl.toDouble(), 
                      data.plPercentage.toDouble(),
                      null,
                      fontSize: 13,
                      iconSize: 15,
                      plPrefix: data.fromAsset
                    )
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
