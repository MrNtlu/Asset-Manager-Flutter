import 'package:asset_flutter/content/models/subscription.dart';
import 'package:asset_flutter/content/pages/portfolio/portfolio_page.dart';
import 'package:flutter/material.dart';

class SDEditColorPicker extends StatefulWidget {
  final Subscription _data;
  late Color selectedColor;

  SDEditColorPicker(this._data, {Key? key}) : super(key: key) {
    selectedColor = Color(_data.color);
  }

  @override
  State<SDEditColorPicker> createState() => _SDEditColorPickerState();
}

class _SDEditColorPickerState extends State<SDEditColorPicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var color in TestData.testChartStatsColor)
          GestureDetector(
            onTap: () {
              setState(() {
                widget.selectedColor = color;
                widget._data.color = color.value;
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
