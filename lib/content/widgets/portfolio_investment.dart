import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:asset_flutter/content/widgets/portfolio_investment_list_cell.dart';
import 'package:asset_flutter/content/widgets/portfolio_section_title.dart';
import 'package:flutter/material.dart';

class PortfolioInvestment extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return 
    MediaQuery.of(context).orientation == Orientation.portrait ?
      Container(
        color: Colors.white,
        child: Column(
          children: [
            InkWell(
              onTap: (() {
                print("Investment Details Pressed");
              }),
              child: const PortfolioSectionTitle("Investments", "Details>")
            ),
            Expanded(
              child: ListView.builder(itemBuilder: ((context, index) {
                  return PortfolioInvestmentListCell();
                }),
                itemExtent: 115,
                itemCount: 20,
                padding: const EdgeInsets.only(top: 4),
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
              ),
            ),
          ],
        ),
      )
    :
      Container(
        color: Colors.white,
        child: InkWell(
          onTap: (() {
            print("Investment Details Pressed");
          }),
          child: const PortfolioSectionTitle("Investments", "Details>")
        ),
      );
  }
}