import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';

class SortListCell extends StatelessWidget {
  final bool isSelected;
  final String _sort;
  final int _index;
  final Function(int) _selectionHandler;
  final double _fontSize;

  const SortListCell(this._sort, this.isSelected, this._index, this._selectionHandler, this._fontSize, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = isSelected
      ? TextStyle(
          fontSize: _fontSize,
          fontWeight: FontWeight.bold
        )
      : TextStyle(fontSize: _fontSize, color: AppColors().lightBlack);

    return ListTile(
      onTap: () => _selectionHandler(_index),      
      title: Text(
        _sort,
        style: style,
      ),
      trailing: isSelected ? const Icon(Icons.check, size: 26) : null
    );
  }
}
