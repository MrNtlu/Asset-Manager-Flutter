import 'package:asset_flutter/common/widgets/dropdown.dart';
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
        Container(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
          child: SDEditTextFieldForm(name, "Name")
        ),
        Container(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: SDEditTextFieldForm(
                  price > 0 ? price.toString() : "", 
                  "Price", 
                  textInputType: TextInputType.number
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
        Container(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
          child: SDEditTextFieldForm(description ?? '', "Description")
        ),
      ],
    );
  }
}

class SDEditTextFieldForm extends StatelessWidget {
  final String _text;
  final String _label;
  final TextInputType textInputType;

  const SDEditTextFieldForm(this._text, this._label, {this.textInputType = TextInputType.name,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputType,
      maxLines: 1,
      initialValue: _text,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(),
        labelText: _label,
      ),
    );
  }
}