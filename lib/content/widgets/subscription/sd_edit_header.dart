import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/currency_sheet.dart';
import 'package:asset_flutter/common/widgets/textformfield.dart';
import 'package:asset_flutter/content/models/requests/subscription.dart';
import 'package:asset_flutter/content/providers/common/currency_sheet_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SDEditHeader extends StatefulWidget {
  late String name;
  late num price;
  late String? description;
  late String currency;

  late final SubscriptionUpdate? updateData;
  late final SubscriptionCreate? createData;

  late final bool isEditing;
  
  SDEditHeader({
    this.name = '',
    this.price = -1,
    this.description,
    this.currency = "USD",
    this.isEditing = false,
    this.createData,
    this.updateData,
    Key? key
  }) : super(key: key);

  @override
  State<SDEditHeader> createState() => _SDEditHeaderState();
}

class _SDEditHeaderState extends State<SDEditHeader> {
  EditState _state = EditState.init;
  late final CurrencySheetSelectionStateProvider _provider;

  void _currencySheetListener() {
    if (_state != ListState.disposed && _provider.symbol != null) {
      widget.currency = _provider.symbol!;
    }
  }

  @override
  void dispose() {
    _provider.removeListener(_currencySheetListener);
    _state = EditState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == EditState.init) {
      _provider = Provider.of<CurrencySheetSelectionStateProvider>(context);
      _provider.addListener(_currencySheetListener);
      _state = EditState.view;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          "Name",
          TextInputType.name,
          initialText: widget.name,
          edgeInsets: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
          textInputAction: TextInputAction.next,
          onSaved: (value) {
            if (value != null) {
              if(widget.isEditing && widget.name != value){
                widget.updateData!.name = value;
              } else if (!widget.isEditing) {
                widget.createData!.name = value;
              }
            }
          },
          validator: (value) {
            if (value != null) {
              if (value.isEmpty) {
                return "Please don't leave this empty.";
              }
            }

            return null;
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: CustomTextFormField(
                "Price", 
                const TextInputType.numberWithOptions(decimal: true, signed: true),
                initialText: widget.price > 0 ? widget.price.toString() : "", 
                edgeInsets: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
                textInputAction: TextInputAction.next,
                onSaved: (value) {
                  if (value != null) {
                    if (widget.isEditing) {
                      widget.updateData!.currency = widget.currency;
                    }

                    final parsedValue = double.parse(value); 
                    if(widget.isEditing && widget.price != parsedValue){
                      widget.updateData!.price = parsedValue;
                    } else if(!widget.isEditing) {
                      widget.createData!.price = parsedValue;
                      widget.createData!.currency = widget.currency;
                    }
                  }
                },
                validator: (value) {
                  if (value != null) {
                    if (value.isEmpty) {
                      return "Please don't leave this empty.";
                    } else if (double.tryParse(value) == null) {
                      return "Price is not valid.";
                    }
                  }

                  return null;
                },
              )
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: TextButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.currency, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const Icon(Icons.arrow_drop_down_rounded, size: 30)
                  ],
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
                  isScrollControlled: true,
                  builder: (_) => CurrencySheet(selectedSymbol: widget.currency)
                ),
              ),
            )
          ],
        ),
        CustomTextFormField(
          "Description",
          TextInputType.name,
          initialText: widget.description ?? '',
          edgeInsets: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
          textInputAction: TextInputAction.done,
          onSaved: (value) {
            if (widget.isEditing) {
              if (widget.description == null || (widget.description != null && widget.description != value)) {
                widget.updateData!.description = value != null ? (value.trim() != '' ? value : null) : null;
              }
            } else {
              widget.createData!.description = value != null ? (value.trim() != '' ? value : null) : null;
            }
          },
        ),
      ],
    );
  }
}