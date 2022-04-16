import 'package:asset_flutter/content/providers/common/stats_toggle_state.dart';
import 'package:asset_flutter/static/colors.dart';
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
      children: const [
        Padding(
          padding: EdgeInsets.all(2),
          child: Text("7 Days", style: TextStyle(fontSize: 12)),
        ),
        Padding(
          padding: EdgeInsets.all(2),
          child: Text("Month", style: TextStyle(fontSize: 12)),
        ),
        Padding(
          padding: EdgeInsets.all(2),
          child: Text("3 Months", style: TextStyle(fontSize: 12)),
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