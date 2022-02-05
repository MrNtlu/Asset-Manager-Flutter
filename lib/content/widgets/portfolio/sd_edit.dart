import 'package:asset_flutter/content/pages/portfolio/portfolio_page.dart';
import 'package:asset_flutter/content/widgets/portfolio/sd_edit_bill_cycle.dart';
import 'package:asset_flutter/content/widgets/portfolio/sd_edit_color_picker.dart';
import 'package:asset_flutter/content/widgets/portfolio/sd_edit_date_picker.dart';
import 'package:asset_flutter/content/widgets/portfolio/sd_edit_header.dart';
import 'package:flutter/material.dart';

class SubscriptionDetailsEdit extends StatefulWidget {
  final TestSubscriptionData _data;
  late final SDEditColorPicker colorPicker;

  SubscriptionDetailsEdit(this._data, {Key? key}) : super(key: key){
    colorPicker = SDEditColorPicker(_data);
  }

  @override
  State<SubscriptionDetailsEdit> createState() => _SubscriptionDetailsEditState();
}

class _SubscriptionDetailsEditState extends State<SubscriptionDetailsEdit> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SDEditHeader(widget._data),
        const Divider(thickness: 1),
        SDEditDatePicker(widget._data),
        const Divider(thickness: 1),
        Container(
          margin: const EdgeInsets.fromLTRB(12, 8, 8, 4),
          alignment: Alignment.centerLeft,
          child: const Text(
            "Bill Cycle",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        SDEditBillCycle(widget._data),
        const Divider(thickness: 1),
        Container(
          margin: const EdgeInsets.fromLTRB(12, 8, 8, 4),
          alignment: Alignment.centerLeft,
          child: const Text(
            "Pick Color",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(12, 8, 8, 4),
          child: widget.colorPicker
        ),
        const Divider(thickness: 1),
      ],
    );
  }
}