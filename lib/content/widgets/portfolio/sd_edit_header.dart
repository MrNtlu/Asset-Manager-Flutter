import 'package:asset_flutter/common/widgets/dropdown.dart';
import 'package:asset_flutter/content/pages/portfolio/portfolio_page.dart';
import 'package:flutter/material.dart';

class SDEditHeader extends StatelessWidget {
  final TestSubscriptionData _data;
  late final Dropdown dropdown;
  
  SDEditHeader(this._data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dropdown = Dropdown(
      const ["USD", "EUR", "GBP", "KRW", "JPY"],
    );
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
          child: SDEditTextFieldForm(_data.name, "Name")
        ),
        Container(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: SDEditTextFieldForm(
                  _data.price.toString(), 
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
          child: SDEditTextFieldForm(_data.description ?? '', "Description")
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