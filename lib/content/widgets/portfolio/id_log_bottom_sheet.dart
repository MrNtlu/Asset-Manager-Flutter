import 'package:asset_flutter/common/widgets/textformfield.dart';
import 'package:asset_flutter/content/widgets/portfolio/investment_toggle_button.dart';
import 'package:flutter/material.dart';

class InvestmentDetailsLogBottomSheet extends StatelessWidget {
  double? price;
  double? amount;
  final String _toAsset;
  late final InvestmentToggleButton _toggleButton;
  final _form = GlobalKey<FormState>();
  final Function(BuildContext, String, double, double, bool) _investmentLogHandler;

  InvestmentDetailsLogBottomSheet(
    this._toAsset, 
    this._investmentLogHandler,
    {
      this.price,
      this.amount,
      bool isSell = false,
      Key? key
    }
  ) : super(key: key){
     _toggleButton = InvestmentToggleButton(isSell: isSell);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
      margin: const EdgeInsets.all(12),
      child: Form(
        key: _form,
        child: Column(
          children: [
            _toggleButton,
            CustomTextFormField(
              "Buy/Sell Price",
              const TextInputType.numberWithOptions(decimal: true),
              initialText: price?.toString(),
              textInputAction: TextInputAction.next,
              onSaved: (value) {
                if (value != null) {
                  price = double.parse(value);
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
            ),
            CustomTextFormField(
              "Amount",
              const TextInputType.numberWithOptions(decimal: true),
              initialText: amount?.toString(),
              textInputAction: TextInputAction.done,
              onSaved: (value) {
                if (value != null) {
                  amount = double.parse(value);
                }
              },
              validator: (value) {
                if (value != null) {
                  if (value.isEmpty) {
                    return "Please don't leave this empty.";
                  } else if (double.tryParse(value) == null) {
                    return "Amount is not valid.";
                  }
                }

                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold))),
                  ElevatedButton(
                      onPressed: () {
                        final _isValid = _form.currentState?.validate();
                        if (_isValid != null && !_isValid) {
                          return;
                        }

                        _form.currentState?.save();
                        Navigator.pop(context);
                        _investmentLogHandler(
                            context,
                            (_toggleButton.isSelected[0] ? "buy" : "sell"),
                            amount!,
                            price!,
                            _toggleButton.isSelected[0]);
                      },
                      child: Text((price != null ? "Update " : "Add ") + _toAsset,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
