import 'package:asset_flutter/common/widgets/sort_list_cell.dart';
import 'package:flutter/material.dart';

class SortList extends StatefulWidget {
  final List<String> sortList;
  late final List<bool> selectedList;

  SortList(this.sortList, {
    Key? key,
    int selectedIndex = 0,
  }) : super(key: key) {
    selectedList = [];
    for (var i = 0; i < sortList.length; i++) {
      selectedList.insert(i, selectedIndex == i ? true : false);
    }
  }

  @override
  State<SortList> createState() => _SortListState();

  String getSelectedItem() => sortList[selectedList.indexOf(true)];
}

class _SortListState extends State<SortList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: ((context, index) {
        final sort = widget.sortList[index];
        final sortSelection = widget.selectedList[index];

        return SortListCell(sort, sortSelection, index, handleSelection);
      }),
      itemCount: widget.sortList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  void handleSelection(int index) {
    for (var i = 0; i < widget.selectedList.length; i++) {
      if (index != i) {
        widget.selectedList[i] = false;
      }
    }

    setState(() {
      widget.selectedList[index] = true;
    });
  }
}
