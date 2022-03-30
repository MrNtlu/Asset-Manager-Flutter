import 'package:asset_flutter/common/widgets/dropdown.dart';
import 'package:asset_flutter/common/widgets/textformfield.dart';
import 'package:asset_flutter/content/models/requests/subscription.dart';
import 'package:asset_flutter/static/currencies.dart';
import 'package:flutter/material.dart';

class SDEditHeader extends StatelessWidget {
  late String name;
  late num price;
  late String? description;
  late String currency;
  late final Dropdown dropdown;

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
  Widget build(BuildContext context) {
    dropdown = Dropdown(
      SupportedCurrencies().currencies,
      dropdownValue: currency,
    );

    return Column(
      children: [
        CustomTextFormField(
          "Name",
          TextInputType.name,
          initialText: name,
          edgeInsets: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
          textInputAction: TextInputAction.next,
          onSaved: (value) {
            if (value != null) {
              if(isEditing && name != value){
                updateData!.name = value;
              } else if (!isEditing) {
                createData!.name = value;
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
        SizedBox(
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: CustomTextFormField(
                  "Price", 
                  const TextInputType.numberWithOptions(decimal: true, signed: true),
                  initialText: price > 0 ? price.toString() : "", 
                  edgeInsets: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    if (value != null) {
                      if (isEditing && currency != dropdown.dropdownValue) {
                        updateData!.currency = dropdown.dropdownValue;
                      }

                      if(isEditing && price != double.parse(value)){
                        updateData!.price = double.parse(value);
                      } else if(!isEditing) {
                        createData!.price = double.parse(value);
                        createData!.currency = dropdown.dropdownValue;
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
                child: dropdown,
              )
            ],
          )
        ),
        CustomTextFormField(
          "Description",
          TextInputType.name,
          initialText: description ?? '',
          edgeInsets: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
          textInputAction: TextInputAction.done,
          onSaved: (value) {
            if (isEditing) {
              if (description == null || (description != null && description != value)) {
                updateData!.description = value != null ? (value.trim() != '' ? value : null) : null;
              }
            } else {
              createData!.description = value != null ? (value.trim() != '' ? value : null) : null;
            }
          },
        ),
      ],
    );
  }
}