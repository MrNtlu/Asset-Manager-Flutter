import 'package:asset_flutter/content/widgets/subscription/cb_info_card.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubscriptionCurrencyBar extends StatefulWidget {
  const SubscriptionCurrencyBar();

  @override
  State<SubscriptionCurrencyBar> createState() => _SubscriptionCurrencyBarState();
}

class _SubscriptionCurrencyBarState extends State<SubscriptionCurrencyBar> {
  final List<String> _dropdownList = ["Monthly", "Total"];
  late String _dropdownValue;

  @override
  void initState() {
    super.initState();
    _dropdownValue = _dropdownList[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Monthly Payments",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          CurrencyBarInfoCard(_dropdownValue == _dropdownList[0]),
          // Container(
          //   margin: const EdgeInsets.only(left: 8, right: 8, top: 4),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 4),
          //           child: CupertinoButton(
          //             borderRadius: const BorderRadius.all(Radius.circular(12)),
          //             color: AppColors().primaryColor,
          //             padding: const EdgeInsets.all(6),
          //             child: Row(
          //               children: const [
          //                 Icon(Icons.credit_card_rounded, size: 24),
          //                 Expanded(
          //                   child: Text(
          //                     "Cards",
          //                     textAlign: TextAlign.center,
          //                   ),
          //                 )
          //               ],
          //             ), 
          //             onPressed: () {}
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         child: Padding(
          //           padding: const EdgeInsets.symmetric(horizontal: 4),
          //           child: CupertinoButton(
          //             borderRadius: const BorderRadius.all(Radius.circular(12)),
          //             color: AppColors().primaryColor,
          //             padding: const EdgeInsets.all(6),
          //             child: Row(
          //               children: const [
          //                 Icon(Icons.bar_chart_rounded, size: 24),
          //                 Expanded(
          //                   child: Text(
          //                     "Statistics",
          //                     textAlign: TextAlign.center,
          //                   ),
          //                 )
          //               ],
          //             ), 
          //             onPressed: () {
          //               //TODO: Implement
          //             }
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}