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
        _toggleButton("Week", 0),
        _toggleButton("Month", 1),
        _toggleButton("Year", 2),
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

  Widget _toggleButton(String _title, int index) {
    if (widget.isSelected[index]) {
      return SizedBox(
        width: 70,
        child: Card(
          color: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _toggleText(_title, widget.isSelected[index]),
          ),
        ),
      );
    }
    return SizedBox(
      width: 70,
      child: _toggleText(_title, widget.isSelected[index])
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