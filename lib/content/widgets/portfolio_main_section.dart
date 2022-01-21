import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:asset_flutter/content/widgets/portfolio_section_title.dart';
import 'package:flutter/material.dart';

class PortfolioMainSection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: TabsPage.darkBlueColor,
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
      child: GestureDetector(
        onTap: () {
          print("Stats Pressed");
        },
        child: Column(children: [
          const PortfolioSectionTitle("Your Portfolio", "", textColor: Colors.white, mainFontSize: 22),
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "15535683.49",
                  softWrap: false,
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Text(
                    "USD",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  true ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                  color: true ? Colors.green : Colors.red.shade700,
                  size: 26,
                ),
                Text(
                  "456569.23",
                  style: TextStyle(
                    fontSize: 20,
                    color: true ? Colors.green : Colors.red.shade700
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}