import 'package:asset_flutter/content/models/asset.dart';
import 'package:asset_flutter/content/pages/portfolio/investment_details_page.dart';
import 'package:asset_flutter/content/pages/portfolio/portfolio_page.dart';
import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:asset_flutter/content/widgets/portfolio/il_cell_image.dart';
import 'package:asset_flutter/content/widgets/portfolio/pl_text.dart';
import 'package:asset_flutter/utils/currency_handler.dart';
import 'package:flutter/material.dart';

class PortfolioInvestmentListCell extends StatelessWidget {
  final AssetDetails data;
  late final String image;

  PortfolioInvestmentListCell(this.data) {
    if (data.type == "crypto") {
      image = TestData.cryptoImage(data.toAsset);
    } else {
      image = TestData.stockImage(data.toAsset);
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
        elevation: 4,
        color: TabsPage.primaryLightishColor,
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
                  color: Colors.white,
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
                      data.currentValue.toString() + ' ' + data.fromAsset,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.only(right: 12, top: 4),
                      child: PortfolioPLText(data.pl, null,
                          fontSize: 13,
                          iconSize: 15,
                          plPrefix: convertCurrencyToSymbol(data.fromAsset)))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
