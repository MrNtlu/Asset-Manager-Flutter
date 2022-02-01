import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:flutter/material.dart';

class InvestmentDetailsLogListCellText extends StatelessWidget {
  final String _firstText;
  final String _secondText;

  const InvestmentDetailsLogListCellText(this._firstText, this._secondText, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _firstText,
                style: const TextStyle(
                    color: TabsPage.lightBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                _secondText,
                style: const TextStyle(
                    color: TabsPage.lightBlack,
                    fontSize: 16,),
              ),
            ),
          )
        ],
      ),
    );
  }
}
