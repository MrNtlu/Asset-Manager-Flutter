import 'package:asset_flutter/static/chart.dart';
import 'package:flutter/material.dart';

class SDEditColorPicker extends StatefulWidget {
  late Color selectedColor;

  SDEditColorPicker({color, Key? key}) : super(key: key) {
    selectedColor = color ?? ChartAttributes().chartStatsColor[0];
  }

  @override
  State<SDEditColorPicker> createState() => _SDEditColorPickerState();
}

class _SDEditColorPickerState extends State<SDEditColorPicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var color in ChartAttributes().chartStatsColor)
          GestureDetector(
            onTap: () {
              setState(() {
                widget.selectedColor = color;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(
                    color: (widget.selectedColor == color)
                        ? Colors.orangeAccent
                        : Colors.transparent),
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 10,
                backgroundColor: color,
              ),
            ),
          ),
      ],
    );
  }
}
