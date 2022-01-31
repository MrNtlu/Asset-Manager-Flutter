import 'package:flutter/material.dart';

class AddElevatedButton extends StatelessWidget {
  final String _label;
  final VoidCallback _onPressed;
  final EdgeInsets edgeInsets;

  const AddElevatedButton(this._label, this._onPressed,{Key? key, this.edgeInsets = const EdgeInsets.all(8)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: edgeInsets,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _onPressed,
        label: Text(_label, style: const TextStyle(fontSize: 18)),
        icon: const Icon(Icons.add_circle, size: 22),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          ),
        ),
      ),
    );
  }
}
