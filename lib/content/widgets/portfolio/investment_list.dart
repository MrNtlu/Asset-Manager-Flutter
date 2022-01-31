import 'dart:io';

import 'package:asset_flutter/common/widgets/add_elevated_button.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
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
          if (TestData.testInvestData.isNotEmpty) 
          Expanded(
            child: ListView.builder(
              itemBuilder: ((context, index) {
                if(index == TestData.testInvestData.length) {
                  return const SizedBox();
                }
                final data = TestData.testInvestData[index];
                return PortfolioInvestmentListCell(data);
              }),
              itemExtent: 75,
              itemCount: TestData.testInvestData.length + 1,
              padding: const EdgeInsets.only(top: 4),
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
            ),
          )
          else const NoItemHolder("Couldn't find investment.", 'Add Investment'),
        ],
      ),
    )
  :
  TestData.testInvestData.isNotEmpty ?
  Container(
    color: Colors.white,
    child: InkWell(
      onTap: (() {
        print("Investment Details Pressed");
      }),
      child: Column(
        children: [
          const SectionTitle("Investments", "See All>"),
          AddElevatedButton("Add Investment", (){

          })
        ],
      )),
    )
    :
    const NoItemHolder("Couldn't find investment.", 'Add Investment');
  }
}
