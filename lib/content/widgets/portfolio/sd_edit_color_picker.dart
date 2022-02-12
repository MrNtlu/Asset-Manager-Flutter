import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';

class SDEditColorPicker extends StatefulWidget {
  late Color selectedColor;

  SDEditColorPicker({color, Key? key}) : super(key: key) {
    selectedColor = color ?? SubscriptionColors().subscriptionColors[0];
  }

  @override
  State<SDEditColorPicker> createState() => _SDEditColorPickerState();
}

class _SDEditColorPickerState extends State<SDEditColorPicker> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var color in SubscriptionColors().subscriptionColors)
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
                      color: (widget.selectedColor.value == color.value)
                          ? Colors.orangeAccent
                          : Colors.transparent),
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: color,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
