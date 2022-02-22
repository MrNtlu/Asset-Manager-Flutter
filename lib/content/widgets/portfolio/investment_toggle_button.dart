import 'package:flutter/material.dart';

class InvestmentToggleButton extends StatefulWidget {
  final List<bool> isSelected = [true, false];

  InvestmentToggleButton({Key? key}) : super(key: key);

  @override
  State<InvestmentToggleButton> createState() => _InvestmentToggleButtonState();
}

class _InvestmentToggleButtonState extends State<InvestmentToggleButton> {
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      color: Colors.black,
      selectedColor: Colors.white,
      borderRadius: BorderRadius.circular(8),
      fillColor: widget.isSelected[0] ? Colors.green : Colors.red,
      children: const [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text("Buy", style: TextStyle(fontSize: 18))),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text("Sell", style: TextStyle(fontSize: 18))),
      ],
      isSelected: widget.isSelected,
      onPressed: (int newIndex) {
        setState(() {
          var falseIndex = newIndex == 0 ? 1 : 0;
          if (!widget.isSelected[newIndex]) {
            widget.isSelected[newIndex] = true;
            widget.isSelected[falseIndex] = false;
          }
        });
      },
    );
  }
}