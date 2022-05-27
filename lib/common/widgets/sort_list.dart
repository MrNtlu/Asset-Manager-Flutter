import 'package:asset_flutter/common/widgets/sort_list_cell.dart';
import 'package:flutter/material.dart';

class SortList extends StatefulWidget {
  final List<String> sortList;
  late final List<bool> selectionList;
  final double fontSize;

  SortList(
    this.sortList, 
    {
      Key? key,
      int selectedIndex = 0,
      this.fontSize = 18,
    }
  ) : super(key: key) {
    selectionList = [];
    for (var i = 0; i < sortList.length; i++) {
      selectionList.insert(i, selectedIndex == i ? true : false);
    }
  }

  @override
  State<SortList> createState() => _SortListState();

  String getSelectedItem() => sortList[selectionList.indexOf(true)];
}

class _SortListState extends State<SortList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: ((context, index) {
        final sort = widget.sortList[index];
        final sortSelection = widget.selectionList[index];

        return SortListCell(sort, sortSelection, index, handleSelection, widget.fontSize);
      }),
      itemCount: widget.sortList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  void handleSelection(int index) {
    for (var i = 0; i < widget.selectionList.length; i++) {
      if (index != i) {
        widget.selectionList[i] = false;
      }
    }

    setState(() {
      widget.selectionList[index] = true;
    });
  }
}
