import 'dart:io';
import 'package:asset_flutter/common/widgets/sort_list.dart';
import 'package:asset_flutter/content/providers/common/stats_sheet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SortSheet extends StatelessWidget {
  final List<String> _sortList;
  final List<String> _sortTypeList; 
  final int selectedSort;
  final int selectedSortType;

  const SortSheet(this._sortList, this._sortTypeList, {
    Key? key,
    this.selectedSort = 0,
    this.selectedSortType = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {    
    var _statsSheetProvider = Provider.of<StatsSheetSelectionStateProvider>(context, listen: false);
    var sortListView = SortList(_sortList, selectedIndex: selectedSort);
    var sortTypeListView = SortList(_sortTypeList, selectedIndex: selectedSortType);

    return SafeArea(
      child: Container(
        height: (50 * _sortList.length).toDouble() + 100,
        decoration: Platform.isIOS || Platform.isMacOS
        ? const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16)
          ),
        )
        : null,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: sortListView
                  ),
                  Expanded(
                    child: sortTypeListView
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Platform.isIOS || Platform.isMacOS
                ? CupertinoButton(
                  child: const Text('Cancel'), 
                  onPressed: () => Navigator.pop(context)
                )
                : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextButton(
                      onPressed: () => Navigator.pop(context), 
                      child: const Text('Cancel')
                    ),
                  ),
                ),
                Platform.isIOS || Platform.isMacOS
                ? CupertinoButton.filled(
                  child: const Text('Apply'), 
                  onPressed: () {
                    _statsSheetProvider.sortSelectionChanged(sortListView.getSelectedItem(), sortTypeListView.getSelectedItem());
                    Navigator.pop(context);
                  }
                )
                : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        _statsSheetProvider.sortSelectionChanged(sortListView.getSelectedItem(), sortTypeListView.getSelectedItem());
                        Navigator.pop(context);
                      }, 
                      child: const Text('Apply')
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}