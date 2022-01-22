import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:flutter/material.dart';

class PortfolioInvestmentListCell extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Card(
      color: TabsPage.primaryColor,
      margin: const EdgeInsets.only(left: 8, bottom: 8, right: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(top: 6, bottom: 6),
              alignment: Alignment.center,
              child: const Text(
                "CMCSA/USD",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        InvestmentCellRow(Icons.account_balance_wallet_rounded,'100.82', 'USD'),
                        InvestmentCellRow(Icons.tag_rounded, '90.1', 'CMCSA'),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8, right: 8),
                  padding: const EdgeInsets.only(bottom: 16),
                  height: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        true ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                        color: true ? TabsPage.greenColor : Colors.red.shade700,
                        size: 19,
                      ),
                      Text(
                        "430.23",
                        style: TextStyle(
                          fontSize: 17,
                          color: true ? TabsPage.greenColor : Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            ),
          ),
        ],
      ) 
    );
  }
}

class InvestmentCellRow extends StatelessWidget {
  final IconData _icon;
  final String _text;
  final String _subText;
  final double iconSize;
  final double textSize;
  final double iconPadding;

  const InvestmentCellRow(this._icon, this._text, this._subText,
      {this.textSize = 16,
      this.iconSize = 18,
      this.iconPadding = 4});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(right: iconPadding),
          child: Icon(
            _icon,
            color: Colors.black,
            size: iconSize,
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: Text(
            _text, 
            style: TextStyle(
              color: Colors.white,
              fontSize: textSize,
              fontWeight: FontWeight.bold
            )
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(left: 6),
          child: Text(
            _subText, 
            style: TextStyle(
              color: Colors.white,
              fontSize: textSize - 4,
            )
          ),
        ),
      ],
    );
  }
}