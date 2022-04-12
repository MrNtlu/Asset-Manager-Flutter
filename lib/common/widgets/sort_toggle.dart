import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';

class SortToggleButton extends StatefulWidget {
  final List<bool> isSelected = [true, false];

  SortToggleButton({bool isDescending = false, Key? key}) : super(key: key){
    if (isDescending) {
      isSelected[0] = false;
      isSelected[1] = true;
    }
  }

  @override
  State<SortToggleButton> createState() => _SortToggleButtonState();
}

class _SortToggleButtonState extends State<SortToggleButton> {
  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      color: Colors.black,
      selectedColor: Colors.white,
      borderRadius: BorderRadius.circular(8),
      fillColor: AppColors().primaryColor,
      isSelected: widget.isSelected,
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: Text("Ascending", style: const TextStyle(fontSize: 14)),
        ),
        Padding(
          padding: const EdgeInsets.all(4),
          child: Text("Descending", style: const TextStyle(fontSize: 14)),
        ),
      ],
      onPressed: (index){
        widget.isSelected[widget.isSelected.indexOf(true)] = false;
        setState(() {
          widget.isSelected[index] = true;
        });
      },
    );
  }
}