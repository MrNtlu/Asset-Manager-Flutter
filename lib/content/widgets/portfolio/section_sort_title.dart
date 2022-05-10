import 'dart:io';
import 'package:asset_flutter/common/widgets/sort_sheet.dart';
import 'package:flutter/material.dart';

class SectionSortTitle extends StatelessWidget {
  final String _title;
  final String sortTitle;
  final int sortType;
  final List<String> _sortList;
  final List<String> _sortTypeList;

  const SectionSortTitle(
    this._title, 
    this._sortList,
    this._sortTypeList,
    {
      Key? key,
      required this.sortTitle,
      required this.sortType
    }
  ) : super(key: key);

 
  @override
  Widget build(BuildContext context) {
    String _sortTitle;
    if (sortTitle == "percentage") {
      _sortTitle = "Profit(%)";
    } else {
      _sortTitle = "${sortTitle[0].toUpperCase()}${sortTitle.substring(1)}";
    }
    var _sortTypeIcon = sortType == -1 ? Icons.arrow_upward_rounded : Icons.arrow_downward;

    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                _title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(_sortTitle),
                    Icon(
                      _sortTypeIcon,
                      size: 16,
                    )
                  ],
                ),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  shape: Platform.isIOS || Platform.isMacOS
                  ? const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16)
                    ),
                  )
                  : null,
                  enableDrag: false,
                  isDismissible: true,
                  isScrollControlled: true,
                  builder: (_) => SortSheet(
                    _sortList,
                    _sortTypeList,
                    selectedSort: _sortList.indexOf(_sortTitle),
                    selectedSortType: _sortTypeIcon == Icons.arrow_upward_rounded ? 0 : 1,
                  )
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}