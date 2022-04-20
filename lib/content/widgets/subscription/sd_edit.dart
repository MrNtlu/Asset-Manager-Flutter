import 'dart:convert';
import 'package:asset_flutter/content/models/requests/subscription.dart';
import 'package:asset_flutter/content/models/responses/subscription.dart';
import 'package:asset_flutter/content/providers/subscription/subscription.dart';
import 'package:asset_flutter/content/widgets/subscription/sd_edit_bill_cycle.dart';
import 'package:asset_flutter/content/widgets/subscription/sd_edit_color_picker.dart';
import 'package:asset_flutter/content/widgets/subscription/sd_edit_date_picker.dart';
import 'package:asset_flutter/content/widgets/subscription/sd_edit_header.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class SubscriptionDetailsEdit extends StatefulWidget {
  final Subscription? _data;
  late final bool isEditing;

  final form = GlobalKey<FormState>();
  late final SubscriptionUpdate? updateData;
  late final SubscriptionCreate? createData;

  late final SDEditDatePicker datePicker;
  late final SDEditBillCycle billCyclePicker;
  late final SDEditColorPicker colorPicker;
  String? selectedDomain;


  SubscriptionDetailsEdit(this._data, {Key? key}) : super(key: key) {
    isEditing = _data != null;
    colorPicker = SDEditColorPicker(
      color: _data != null ? Color(_data!.color) : null,
    );
    datePicker = SDEditDatePicker(billDate: _data?.billDate ?? DateTime.now());
    billCyclePicker = SDEditBillCycle(billCycle: _data?.billCycle.copyWith() ?? BillCycle(month: 1));

    if (isEditing) {
      updateData = SubscriptionUpdate(_data!.id);
    } else {
      createData = SubscriptionCreate('', BillCycle(), DateTime.now(), 0.0, '',  null, 0);
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
        _createSubscriptionDropdown(),
        Form(
          key: widget.form,
          child: widget.isEditing ? 
          SDEditHeader(
            name: widget._data!.name,
            price: widget._data!.price,
            description: widget._data!.description,
            currency: widget._data!.currency,
            updateData: widget.updateData,
            isEditing: true,
          )
          : 
          SDEditHeader(
            createData: widget.createData,
          )
        ),
        const Divider(thickness: 1),
        widget.datePicker,
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
        widget.billCyclePicker,
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

  Widget _createSubscriptionDropdown() => Container(
    margin:const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
    child: DropdownSearch<String>(
      showSearchBox: true,
      selectedItem: widget._data?.rawImage,
      dropdownSearchDecoration: const InputDecoration(
        label: Text('Subscription Service'),
        contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
        border: OutlineInputBorder(),
      ),
      showClearButton: true,
      isFilteredOnline: true,
      searchDelay: const Duration(milliseconds: 600),
      onFind: (String? filter) async {
        List<String> _itemList = [];
        if (filter == null || (filter.trim() == '')) {
          filter = "netflix";
        }
        var response = await http.get(
          Uri.parse("https://autocomplete.clearbit.com/v1/companies/suggest?query=$filter"),
        );
        (json.decode(response.body) as List).map((e) => e as Map<String, dynamic>).forEach((element) {
            _itemList.add(element["domain"] as String);
        }); 

        return _itemList;
      },
      onChanged: (String? item) => widget.selectedDomain = item,
      itemAsString: (String? item) => item ?? '',
    ),
  );
}
