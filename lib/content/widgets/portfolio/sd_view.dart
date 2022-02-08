import 'package:asset_flutter/content/providers/subscription.dart';
import 'package:asset_flutter/content/widgets/portfolio/sd_view_text.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SubscriptionDetailsView extends StatelessWidget {
  final Subscription _data;

  const SubscriptionDetailsView(this._data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 110,
          width: double.infinity,
          color: Color(_data.color),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                  alignment: Alignment.bottomCenter,
                  child: AutoSizeText(
                    _data.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                    ),
                  ),
                )
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 6),
                  alignment: Alignment.topCenter,
                  child: Text(
                    _data.price.toString() + ' ' + _data.currency,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ),
                )
              )
            ],
          ),
        ),
        if(_data.description != null)
        SDViewText("Description", _data.description!),
        SDViewText("Initial Bill Date", _data.billDate.dateToFormatDate()),
        SDViewText("Bill Cycle", _data.billCycle.handleBillCycleString()),
        const SDViewText("Paid in Total", "1506.34"),
        Padding(
          padding: const EdgeInsets.all(12),
          child: OutlinedButton(
            onPressed: () {
              print("Delete Subscription");
            },
            child: const Text("Delete Subscription")
          ),
        )
      ],
    );
  }
}