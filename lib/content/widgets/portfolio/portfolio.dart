import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:asset_flutter/content/widgets/portfolio/pl_text.dart';
import 'package:asset_flutter/content/widgets/portfolio/section_title.dart';
import 'package:flutter/material.dart';

class Portfolio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
      child: GestureDetector(
        onTap: () {
          print("Stats Pressed");
          
        },
        child: Column(children: [
          const SectionTitle("Your Portfolio", "", mainFontSize: 22),
          Container(
            margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              color: TabsPage.primaryLightishColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "15535683.49",
                            softWrap: false,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width > 350 ? 36 : 32,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Padding(
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
                      child: PortfolioPLText(
                        -456569.23, 
                        "USD", 
                        fontSize: MediaQuery.of(context).size.width > 350 ? 20 : 16, 
                        iconSize: MediaQuery.of(context).size.width > 350 ? 22 : 18
                      )
                      
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}