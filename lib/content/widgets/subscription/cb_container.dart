import 'package:flutter/material.dart';

class SubscriptionCurrencyBarContainer extends StatelessWidget {
  final int _flex;
  final int _index;
  final Color _color;
  final int _listSize;
  late final BoxDecoration _decoration;

  SubscriptionCurrencyBarContainer(this._flex, this._index, this._color, this._listSize){
    if(_index == 0 && _index == _listSize - 1) {
      _decoration = BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8)
        ),
        color: _color,
      );
    } else if(_index == 0){
      _decoration = BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          bottomLeft: Radius.circular(8),
        ),
        color: _color,
      );
    } else if(_index == _listSize - 1) {
      _decoration = BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8)
        ),
        color: _color,
      );
    } else {
      _decoration = BoxDecoration(
        color: _color,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: _flex,
      child: Container(
        height: 20,
        margin: const EdgeInsets.only(top: 8, bottom: 4),
        decoration: _decoration
      ),
    );
  }
}