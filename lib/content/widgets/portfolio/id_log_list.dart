import 'package:asset_flutter/content/pages/portfolio/portfolio_page.dart';
import 'package:asset_flutter/content/widgets/portfolio/id_list_cell.dart';
import 'package:flutter/material.dart';

class InvestmentDetailsLogList extends StatelessWidget {
  final double _appBarHeight;

  const InvestmentDetailsLogList(this._appBarHeight, {Key? key}) : super(key: key);
  //TODO: https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/learn/lecture/15100258#questions
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - ( 
        _appBarHeight + 
        MediaQuery.of(context).padding.top + 
        MediaQuery.of(context).padding.bottom),
      child: ListView.builder(
        itemBuilder: (context, index) {
          if (index == 0) {
            return const SizedBox(height: 100);
          } else if (index == TestData.testInvestLogData.length + 1){
            return const SizedBox(height: 65);
          }

          final data = TestData.testInvestLogData[index - 1];

          return InvestmentDetailsListCell(data);
        },
        itemCount: TestData.testInvestLogData.length + 2,
        padding: const EdgeInsets.only(top: 4),
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }
}