import 'dart:io';

import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/content/providers/portfolio/watchlist_search.dart';
import 'package:asset_flutter/content/widgets/market/market_dropdowns.dart';
import 'package:asset_flutter/content/widgets/portfolio/wl_sheet_list.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistAddSheet extends StatefulWidget {
  
  const WatchlistAddSheet({Key? key}) : super(key: key);

  @override
  State<WatchlistAddSheet> createState() => _WatchlistAddSheetState();
}

class _WatchlistAddSheetState extends State<WatchlistAddSheet> {
  BaseState _state = BaseState.init;

  late final WatchlistSearchProvider _provider;
  late final TextEditingController _searchTextController;

  @override
  void dispose() {
    _state = BaseState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == BaseState.init) {
      _provider = WatchlistSearchProvider();
      _searchTextController = TextEditingController(text: _provider.search);

      _state = BaseState.loading;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: SafeArea(
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
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _searchTextController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search_rounded),
                          hintText: "Search",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: AppColors().bgSecondary)
                          ),
                        ),
                        maxLines: 1,
                        onFieldSubmitted: _provider.submitSearch,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Platform.isIOS || Platform.isMacOS
                        ? CupertinoButton(
                          child: const Text('Search', style: TextStyle(color: CupertinoColors.activeBlue, fontSize: 14)),
                          onPressed: () => _provider.submitSearch(_searchTextController.text),
                        )
                        : TextButton(
                          child: const Text('Search', style: TextStyle(color: CupertinoColors.activeBlue, fontSize: 14)),
                          onPressed: () => _provider.submitSearch(_searchTextController.text),
                        ),
                      )
                  ],
                ),
              ),
              const WatchlistSheetList(),
            ],
          ),
        ),
      ),
    );
  }
}