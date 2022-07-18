import 'dart:io';
import 'package:asset_flutter/content/providers/portfolio/watchlist.dart';
import 'package:asset_flutter/content/widgets/market/market_dropdowns.dart';
import 'package:asset_flutter/content/widgets/portfolio/watchlist_cell.dart';
import 'package:asset_flutter/content/widgets/portfolio/wl_sheet_list.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/purchase_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistList extends StatelessWidget {
  const WatchlistList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _data = Provider.of<WatchListProvider>(context).items;
    final isPremium = PurchaseApi().userInfo?.isPremium ?? false;

    //TODO: Add loading
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        if (
          (
            (!isPremium && _data.length < 5) ||
            (isPremium && _data.length < 10)
          ) &&
          index == _data.length
        ) {
          return GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context, 
                isDismissible: true,
                isScrollControlled: true,
                enableDrag: false,
                shape: Platform.isIOS || Platform.isMacOS
                ? const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    topLeft: Radius.circular(16)
                  ),
                )
                : null,
                builder: (_) => SafeArea(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
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
                        const MarketDropdowns(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 2, 4, 8),
                          child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search_rounded),
                              hintText: "Search",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppColors().bgSecondary)
                              ),
                            ),
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        const WatchlistSheetList(),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: SizedBox(
              width: 100,
              child: Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.bgColor,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Column(
                  children: [
                    Expanded(
                      child: Icon(
                        Icons.add_box_rounded,
                        color: AppColors().primaryLightishColor,
                        size: 32,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      child: Text(
                        "Add Symbol",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors().primaryLightishColor
                        )
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else if (!isPremium && _data.length > 5 && index == _data.length) {
          //TODO: Show can be premoium to increase the limit
          return SizedBox(
            width: 100,
            child: Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.bgColor,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Column(
                children: [
                  Expanded(
                    child: Icon(
                      Icons.add_box_rounded,
                      color: AppColors().primaryLightishColor,
                      size: 32,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    child: Text(
                      "Add Symbol",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors().primaryLightishColor
                      )
                    ),
                  )
                ],
              ),
            ),
          );
        }

        final data = _data[index];
        return WatchlistCell(data);
      },
      shrinkWrap: true,
      itemCount: (isPremium && _data.length >= 10)
      ? _data.length
      : _data.length + 1,
    );
  }
}