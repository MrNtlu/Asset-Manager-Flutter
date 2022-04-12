import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';

class SortListCell extends StatelessWidget {
  bool isSelected;
  final String _sort;
  final int _index;
  Function(int) _selectionHandler;

  SortListCell(this._sort, this.isSelected, this._index, this._selectionHandler, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedColor = AppColors().primaryLightColor;
    final style = isSelected
      ? TextStyle(
          fontSize: 18,
          color: selectedColor,
          fontWeight: FontWeight.bold
        )
      : TextStyle(fontSize: 18);

    return ListTile(
      onTap: () => _selectionHandler(_index),
      title: Text(
        _sort,
        style: style,
      ),
      trailing: isSelected ? Icon(Icons.check, color: selectedColor, size: 26) : null
    );
  }
}
