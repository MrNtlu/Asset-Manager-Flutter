import 'package:flutter/material.dart';

class ExpandedDivider extends StatelessWidget {
  final double leftInset;
  final double rightInset;
  final double height;
  final Color color;

  const ExpandedDivider(this.leftInset, this.rightInset, this.height, {this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: leftInset, right: rightInset),
        child: Divider(
          color: color,
          height: height,
        ),
      ),
    );
  }
}
