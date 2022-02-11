import 'package:asset_flutter/content/models/requests/subscription.dart';
import 'package:asset_flutter/content/models/responses/subscription.dart';
import 'package:asset_flutter/content/providers/subscription.dart';
import 'package:asset_flutter/content/widgets/portfolio/sd_edit_bill_cycle.dart';
import 'package:asset_flutter/content/widgets/portfolio/sd_edit_color_picker.dart';
import 'package:asset_flutter/content/widgets/portfolio/sd_edit_date_picker.dart';
import 'package:asset_flutter/content/widgets/portfolio/sd_edit_header.dart';
import 'package:flutter/material.dart';

class SubscriptionDetailsEdit extends StatefulWidget {
  final Subscription? _data;

  final form = GlobalKey<FormState>();
  late final SubscriptionUpdate? updateData;
  late final SubscriptionCreate? createData;

  late final SDEditColorPicker colorPicker;
  late final bool isEditing;

  SubscriptionDetailsEdit(this._data, {Key? key}) : super(key: key) {
    isEditing = _data != null;
    colorPicker = SDEditColorPicker();
    if (isEditing) {
      updateData = SubscriptionUpdate(_data!.id);
    } else {
      createData = SubscriptionCreate('', BillCycle(), 0.0, '', null, 0);
    }
  }

  @override
  State<SubscriptionDetailsEdit> createState() => _SubscriptionDetailsEditState();
}

class _SubscriptionDetailsEditState extends State<SubscriptionDetailsEdit> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: widget.form,
          child: widget._data != null ? 
          SDEditHeader(
            name: widget._data!.name,
            price: widget._data!.price,
            description: widget._data!.description,
          )
          : 
          SDEditHeader()
        ),
        const Divider(thickness: 1),
        SDEditDatePicker(billDate: widget._data?.billDate ?? DateTime.now()),
        const Divider(thickness: 1),
        Container(
          margin: const EdgeInsets.fromLTRB(12, 8, 8, 4),
          alignment: Alignment.centerLeft,
          child: const Text(
            "Bill Cycle",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SDEditBillCycle(
            billCycle: widget._data?.billCycle ?? BillCycle(month: 1)),
        const Divider(thickness: 1),
        Container(
          margin: const EdgeInsets.fromLTRB(12, 8, 8, 4),
          alignment: Alignment.centerLeft,
          child: const Text(
            "Pick Color",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(12, 8, 8, 4),
            child: widget.colorPicker),
        const Divider(thickness: 1),
      ],
    );
  }
}
