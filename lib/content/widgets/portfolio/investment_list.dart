import 'dart:io';

import 'package:asset_flutter/content/pages/portfolio/portfolio_page.dart';
import 'package:asset_flutter/content/widgets/portfolio/il_cell.dart';
import 'package:asset_flutter/content/widgets/portfolio/section_title.dart';
import 'package:flutter/material.dart';

class PortfolioInvestment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait  || Platform.isMacOS || Platform.isWindows ? 
    Container(
      color: Colors.white,
      child: Column(
        children: [
          const SectionTitle("Investments", ""),
          Expanded(
            child: ListView.builder(
              itemBuilder: ((context, index) {
                final data = TestData.testInvestData[index];
                return PortfolioInvestmentListCell(data);
              }),
              itemExtent: 75,
              itemCount: TestData.testInvestData.length,
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
      child: const SectionTitle("Investments", "See All>")),
    );
  }
}
