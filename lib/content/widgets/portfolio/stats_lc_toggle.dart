import 'package:asset_flutter/content/providers/portfolio/stats_toggle_state.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatsLineChartToggleButton extends StatefulWidget {
  StatsLineChartToggleButton({Key? key}) : super(key: key);

  @override
  State<StatsLineChartToggleButton> createState() => _StatsLineChartToggleButtonState();
}

class _StatsLineChartToggleButtonState extends State<StatsLineChartToggleButton> {
  bool isInit = false;
  List<bool> _selectedList = [true, false, false];
  late final StatsToggleSelectionStateProvider _statsSelectionProvider;

  @override
  void didChangeDependencies() {
    if (!isInit) {
      _statsSelectionProvider = Provider.of<StatsToggleSelectionStateProvider>(context, listen: false);
      isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      children: [
        Padding(
          padding: const EdgeInsets.all(2),
          child: Text("7 Days", style: const TextStyle(fontSize: 12)),
        ),
        Padding(
          padding: const EdgeInsets.all(2),
          child: Text("Month", style: const TextStyle(fontSize: 12)),
        ),
        Padding(
          padding: const EdgeInsets.all(2),
          child: Text("3 Months", style: const TextStyle(fontSize: 12)),
        ),
      ],
      borderRadius: BorderRadius.circular(8),
      fillColor: AppColors().primaryColor,
      selectedColor: Colors.white,
      isSelected: _selectedList,
      onPressed: (index){
        _selectedList[_selectedList.indexOf(true)] = false;
        _statsSelectionProvider.newIntervalSelected(
          index == 0 
          ? "weekly"
          : (
            index == 1
              ? "monthly"
              : "3monthly"
          )
        );
        setState(() {
          _selectedList[index] = true;
        });
      },
    );
  }
}