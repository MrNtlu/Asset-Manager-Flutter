import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {
  final bool _isSelected;
  final String _title;
  final double width;
  final EdgeInsets edgeInsets;

  const ToggleButton(this._isSelected, this._title, {
    this.width = 70,
    this.edgeInsets = const EdgeInsets.all(8),
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_isSelected) {
      return SizedBox(
        width: width,
        child: Card(
          color: Theme.of(context).colorScheme.toggleColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: edgeInsets,
            child: _toggleText(_title, _isSelected, context),
          ),
        ),
      );
    }
    return SizedBox(
      width: 70,
      child: _toggleText(_title, _isSelected, context),
    );
  }

  Widget _toggleText(String _title, bool _isSelected, BuildContext context) => Text(
    _title, 
    textAlign: TextAlign.center,
    style: TextStyle(
      color: _isSelected ? Theme.of(context).colorScheme.toggleTextColor : Theme.of(context).colorScheme.toggleColor,
      fontSize: 14,
      fontWeight: _isSelected ? FontWeight.bold : FontWeight.normal
    )
  );
}