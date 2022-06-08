import 'package:asset_flutter/common/widgets/toggle_button.dart';
import 'package:asset_flutter/content/providers/wallet/transaction_stats_toggle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionStatsToggle extends StatefulWidget {
  final List<bool> isSelected = [false, false, false];

  TransactionStatsToggle({String interval = "monthly", Key? key}){
    switch (interval) {
      case "weekly":
        isSelected[0] = true;
        break;
      case "yearly":
        isSelected[2] = true;
        break;
      case "monthly":
      default:
        isSelected[1] = true;
    }
  }

  @override
  State<TransactionStatsToggle> createState() => _TransactionStatsToggleState();
}

class _TransactionStatsToggleState extends State<TransactionStatsToggle> {
  late final TransactionStatsToggleProvider _provider;

  @override
  void didChangeDependencies() {
    _provider = Provider.of<TransactionStatsToggleProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      borderWidth: 0,
      selectedColor: Colors.transparent,
      borderColor: Colors.transparent,
      fillColor: Colors.transparent,
      selectedBorderColor: Colors.transparent,
      disabledBorderColor: Colors.transparent,
      splashColor: Colors.transparent,
      children: [
        ToggleButton(widget.isSelected[0], "Week"),
        ToggleButton(widget.isSelected[1], "Month"),
        ToggleButton(widget.isSelected[2], "Year"),
      ],
      isSelected: widget.isSelected,
      onPressed: (int newIndex) {
        widget.isSelected[widget.isSelected.indexOf(true)] = false;
        setState(() {
          widget.isSelected[newIndex] = true;
        });
        _provider.onIntervalChanged(
          newIndex == 0
          ? "weekly"
          : (newIndex == 1)
            ? "monthly"
            : "yearly"
        );
      },
    );
  }
}