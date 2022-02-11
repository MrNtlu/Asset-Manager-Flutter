import 'package:asset_flutter/common/widgets/dropdown.dart';
import 'package:asset_flutter/common/widgets/textformfield.dart';
import 'package:flutter/material.dart';

class SDEditHeader extends StatelessWidget {
  late String name;
  late double price;
  late String? description;
  late final Dropdown dropdown;
  
  SDEditHeader({
    this.name = '',
    this.price = -1,
    this.description,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dropdown = Dropdown(
      const ["USD", "EUR", "GBP", "KRW", "JPY"],
    );
    return Column(
      children: [
        CustomTextFormField(
          "Name",
          TextInputType.name,
          initialText: name,
          edgeInsets: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
        ),
        SizedBox(
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: CustomTextFormField(
                  "Price", 
                  TextInputType.number,
                  initialText: price > 0 ? price.toString() : "", 
                  edgeInsets: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
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
        ),
      ],
    );
  }
}