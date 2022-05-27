import 'package:asset_flutter/content/providers/wallet/transaction.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TransactionFilterSheetCategoryList extends StatefulWidget {
  Category? selectedCategory;

  TransactionFilterSheetCategoryList({Key? key}) : super(key: key);

  @override
  State<TransactionFilterSheetCategoryList> createState() => _TransactionFilterSheetCategoryListState();
}

class _TransactionFilterSheetCategoryListState extends State<TransactionFilterSheetCategoryList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final isSelected = widget.selectedCategory != null && Category.values.indexOf(widget.selectedCategory!) == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                if (widget.selectedCategory != null && Category.values[index] == widget.selectedCategory) {
                  widget.selectedCategory = null;
                } else {
                  widget.selectedCategory = Category.values[index];
                }
              });
            },
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: Category.values[index].iconColor
                )
              ),
              color: isSelected ? Category.values[index].iconColor : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Icon(
                      Category.values[index].icon,
                      color: isSelected ? Colors.white : Category.values[index].iconColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Text(
                        "${Category.values[index].name[0].toUpperCase()}${Category.values[index].name.substring(1)}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white : Colors.black
                        )
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: Category.values.length,
      ),
    );
  }
}