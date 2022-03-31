import 'dart:io';

import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/providers/market/market_selection_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:asset_flutter/static/colors.dart';

class MarketList extends StatefulWidget {
  MarketList({Key? key}) : super(key: key);

  @override
  State<MarketList> createState() => _MarketListState();
}

class _MarketListState extends State<MarketList> {
  ListState _state = ListState.init;
  String? _error;
  

  void _getMarketPrices({type = "crypto", market = "CoinMarketCap"}) {
    setState(() {
      _state = ListState.loading;
    });



    setState(() {
      _state = ListState.done;
    });
  }

  @override
  void dispose() {
    _state = ListState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      _getMarketPrices();

      var _refreshListener = Provider.of<MarketSelectionStateProvider>(context);
      _refreshListener.addListener(() {
        if (_state != ListState.disposed && _refreshListener.market != null && _refreshListener.type != null) {
          _getMarketPrices(type: _refreshListener.type, market: _refreshListener.market);
        }
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _portraitBody();
  }

  Widget _portraitBody() {
    switch (_state) {
      case ListState.loading:
        return const LoadingView("Fetching Market Prices");
      case ListState.error:
        return ErrorView(_error ?? "Unknown error!", _getMarketPrices);
      case ListState.empty:
        return const NoItemView("Couldn't find anything.");
      case ListState.done:
        return Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors().primaryDarkestColor,
                width: 0.5
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6),
              )
            ),
            clipBehavior: Clip.antiAlias,
            child: CustomScrollView(
              slivers: [
                MultiSliver(
                  children: [
                    SliverPinnedHeader(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          )
                        ),
                        margin: const EdgeInsets.all(0),
                        elevation: 5,
                        color: AppColors().primaryColor,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Name/Symbol",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              ),
                              const Text(
                                "Price",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              ),
                            ]
                          ),
                        ),
                      )
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index){
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          color: index % 2 == 0 ? AppColors().primaryLightColor: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Bitcoin/BTC", 
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 16
                                ),
                              ),
                              const Text(
                                "40923.23", 
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 16
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: 5)
                    ),
                  ],
                ),
              ]
            ),
          ),
        );
      default:
        return const LoadingView("Loading");
    }
  }
}