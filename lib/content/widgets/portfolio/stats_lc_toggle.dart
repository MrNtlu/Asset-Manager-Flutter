import 'package:asset_flutter/common/widgets/toggle_button.dart';
import 'package:asset_flutter/content/providers/common/stats_toggle_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatsLineChartToggleButton extends StatefulWidget {
  const StatsLineChartToggleButton({Key? key}) : super(key: key);

  @override
  State<StatsLineChartToggleButton> createState() => _StatsLineChartToggleButtonState();
}

class _StatsLineChartToggleButtonState extends State<StatsLineChartToggleButton> {
  bool isInit = false;
  final List<bool> _selectedList = [true, false, false];
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
        ToggleButton(_selectedList[0], "Week", width: 80, edgeInsets: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),),
        ToggleButton(_selectedList[1], "Month", width: 80, edgeInsets: const EdgeInsets.symmetric(vertical: 8, horizontal: 4)),
        ToggleButton(_selectedList[2], "Year", width: 80, edgeInsets: const EdgeInsets.symmetric(vertical: 8, horizontal: 4)),
      ],
      borderRadius: BorderRadius.circular(8),
      borderWidth: 0,
      selectedColor: Colors.transparent,
      borderColor: Colors.transparent,
      fillColor: Colors.transparent,
      selectedBorderColor: Colors.transparent,
      disabledBorderColor: Colors.transparent,
      splashColor: Colors.transparent,
      isSelected: _selectedList,
      onPressed: (index){
        _selectedList[_selectedList.indexOf(true)] = false;
        _statsSelectionProvider.newIntervalSelected(
          index == 0 
          ? "weekly"
          : (
            index == 1
              ? "monthly"
              : "yearly"
          )
        );
        setState(() {
          _selectedList[index] = true;
        });
      },
    );
  }
}