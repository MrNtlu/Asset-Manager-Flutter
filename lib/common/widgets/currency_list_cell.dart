import 'package:flutter/material.dart';
import 'package:asset_flutter/static/colors.dart';

class CurrencyListCell extends StatelessWidget {
  final bool isSelected;
  final String _currency;
  final int _index;
  final Function(int) _selectionHandler;

  const CurrencyListCell(this._currency, this.isSelected, this._index, this._selectionHandler, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _selectionHandler(_index),
      title: Text(
        _currency,
        style: isSelected 
        ? const TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.bold
        )
        : TextStyle(fontSize: 18, color: AppColors().lightBlack),
      ),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.black, size: 26) : null
    );
  }
}