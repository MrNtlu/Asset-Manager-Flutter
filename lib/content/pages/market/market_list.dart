import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/providers/market/market_selection_state.dart';
import 'package:asset_flutter/content/providers/market/prices.dart';
import 'package:asset_flutter/utils/extensions.dart';
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
  late final PricesProvider _pricesProvider;


  void _getMarketPrices({type = "crypto", market = "CoinMarketCap"}) {
    setState(() {
      _state = ListState.loading;
    });

    _pricesProvider.getMarketPrices(type: type, market: market).then((response) {
      _error = response.error;
      if (_state != ListState.disposed) {  
        setState(() {
          _state = (response.code != null || response.error != null)
            ? ListState.error
            : (
              response.data.isEmpty
                ? ListState.empty
                : ListState.done
            );
        });
      }
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
      _pricesProvider = Provider.of<PricesProvider>(context);
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
    return Expanded(child: _portraitBody());
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
        return Container(
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
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            ),
                            Text(
                              "Price(${_pricesProvider.items[0].currency == '' ? 'USD' : _pricesProvider.items[0].currency})",
                              style: const TextStyle(
                                fontSize: 20,
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
                      var item = _pricesProvider.items[index];

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        color: index % 2 == 0 ? AppColors().primaryLightColor: Colors.white,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                item.name != item.symbol ? "${item.name}/${item.symbol}" : item.name, 
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                item.price.numToString(), 
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: _pricesProvider.items.length)
                  ),
                ],
              ),
            ]
          ),
        );
      default:
        return const LoadingView("Loading");
    }
  }
}