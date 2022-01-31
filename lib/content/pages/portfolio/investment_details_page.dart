import 'package:asset_flutter/common/widgets/add_elevated_button.dart';
import 'package:asset_flutter/content/pages/portfolio/portfolio_page.dart';
import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:asset_flutter/content/widgets/portfolio/il_cell_image.dart';
import 'package:asset_flutter/content/widgets/portfolio/pl_text.dart';
import 'package:asset_flutter/utils/currency_handler.dart';
import 'package:flutter/material.dart';

class InvestmentDetailsPage extends StatelessWidget {
  final TestInvestData data;

  const InvestmentDetailsPage(this.data);

  @override
  Widget build(BuildContext context) {
    final AppBar appBar = AppBar(
      title: Text(data.symbol + '/' + data.fromAsset),
      backgroundColor: TabsPage.primaryLightishColor,
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: Column(
        children: [
          Container(
            height: 300,
            color: TabsPage.primaryLightishColor,
            child: Row(
              children: [
                //TODO: total_value, sold_value, remaining_amount, p/l
                InvestmentListCellImage(TestData.cryptoImage(data.symbol), data.type),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: Text(
                    data.symbol,
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
                          data.value.toString() + ' ' + data.fromAsset,
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
          AddElevatedButton(('Add ' + data.symbol), () {
            print('Add ' + data.symbol);
          })
        ],
      ),
    );
  }
}
