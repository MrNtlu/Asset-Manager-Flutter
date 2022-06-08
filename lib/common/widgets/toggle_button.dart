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
          color: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: edgeInsets,
            child: _toggleText(_title, _isSelected),
          ),
        ),
      );
    }
    return SizedBox(
      width: 70,
      child: _toggleText(_title, _isSelected)
    );
  }

  Widget _toggleText(String _title, bool _isSelected) => Text(
    _title, 
    textAlign: TextAlign.center,
    style: TextStyle(
      color: _isSelected ? Colors.white : Colors.black54,
      fontSize: 14,
      fontWeight: _isSelected ? FontWeight.bold : FontWeight.normal
    )
  );
}