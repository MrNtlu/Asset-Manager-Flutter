import 'dart:convert';
import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/content/models/requests/subscription.dart';
import 'package:asset_flutter/content/models/responses/subscription.dart';
import 'package:asset_flutter/content/providers/subscription/card.dart';
import 'package:asset_flutter/content/providers/subscription/card_sheet_state.dart';
import 'package:asset_flutter/content/providers/subscription/cards.dart';
import 'package:asset_flutter/content/providers/subscription/subscription.dart';
import 'package:asset_flutter/content/widgets/subscription/card_sheet.dart';
import 'package:asset_flutter/content/widgets/subscription/sd_edit_bill_cycle.dart';
import 'package:asset_flutter/content/widgets/subscription/sd_edit_color_picker.dart';
import 'package:asset_flutter/content/widgets/subscription/sd_edit_date_picker.dart';
import 'package:asset_flutter/content/widgets/subscription/sd_edit_header.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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
  CreditCard? selectedCard;

  SubscriptionDetailsEdit(this._data, {Key? key}) : super(key: key) {
    isEditing = _data != null;
    colorPicker = SDEditColorPicker(
      color: _data != null ? Color(_data!.color) : null,
    );
    datePicker = SDEditDatePicker(billDate: _data?.billDate ?? DateTime.now());
    billCyclePicker = SDEditBillCycle(billCycle: _data?.billCycle.copyWith() ?? BillCycle(month: 1));
    selectedCard = (_data != null && _data!.cardID != null) ? CreditCard(_data!.cardID!, '', '', '', '', '', '') :  null;

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
  EditState _state = EditState.init;
  late final CardSheetSelectionStateProvider _cardSelectionProvider;

  void _cardSheetSelectionListener() {
    if (_state != EditState.disposed) {
      setState(() {
        widget.selectedCard = _cardSelectionProvider.selectedCard;
      });
    }
  }

  @override
  void dispose() {
    _cardSelectionProvider.removeListener(_cardSheetSelectionListener);
    _state = EditState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == EditState.init) {
      if(widget.isEditing && widget.selectedCard != null) {
        widget.selectedCard = Provider.of<CardProvider>(context).findById(widget.selectedCard!.id);
      }
      _cardSelectionProvider = Provider.of<CardSheetSelectionStateProvider>(context);
      _cardSelectionProvider.addListener(_cardSheetSelectionListener);
      _state = EditState.view;
    }
    super.didChangeDependencies();
  }

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
        _subSectionTitle("Bill Cycle"),
        widget.billCyclePicker,
        const Divider(thickness: 1),
        _subSectionTitle("Pick Color"),
        Container(
          margin: const EdgeInsets.fromLTRB(12, 8, 8, 4),
          child: widget.colorPicker
        ),
        const Divider(thickness: 1),
        _subSectionTitle("Credit Card (Optional)"),
        Container(
          margin: const EdgeInsets.fromLTRB(12, 8, 8, 4),
          child: TextButton(
            child: Text(
              widget.selectedCard != null
              ? "${widget.selectedCard!.name} ${widget.selectedCard!.lastDigits}"
              : "No Card Selected",
              style: const TextStyle(fontSize: 16),
            ),
            onPressed: () => showModalBottomSheet(
              context: context,
              shape: Platform.isIOS || Platform.isMacOS
              ? const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  topLeft: Radius.circular(16)
                ),
              )
              : null,
              enableDrag: false,
              isDismissible: true,
              builder: (_) => CardSelectionSheet(widget.selectedCard)
            ),
          ),
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
      searchDelay: const Duration(milliseconds: 500),
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

  Widget _subSectionTitle(String title) => Container(
    margin: const EdgeInsets.fromLTRB(12, 8, 8, 4),
    alignment: Alignment.centerLeft,
    child: Text(
      title,
      style: const TextStyle(
        color: Colors.black, 
        fontSize: 16, 
        fontWeight: FontWeight.bold
      ),
    ),
  );
}
