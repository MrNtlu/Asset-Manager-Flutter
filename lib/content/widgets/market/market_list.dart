import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/providers/market/market_selection_state.dart';
import 'package:asset_flutter/content/providers/market/prices.dart';
import 'package:asset_flutter/content/widgets/market/market_list_cell.dart';
import 'package:asset_flutter/content/widgets/market/market_list_header.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';

class MarketList extends StatefulWidget {
  const MarketList({Key? key}) : super(key: key);

  @override
  State<MarketList> createState() => _MarketListState();
}

class _MarketListState extends State<MarketList> {
  ListState _state = ListState.init;
  String? _error;
  late final PricesProvider _pricesProvider;
  late final MarketSelectionStateProvider _marketSelectionProvider;


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
    _marketSelectionProvider.type = null;
    _marketSelectionProvider.market = null;
    _state = ListState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      _pricesProvider = Provider.of<PricesProvider>(context);
      _getMarketPrices();

      _marketSelectionProvider = Provider.of<MarketSelectionStateProvider>(context);
      _marketSelectionProvider.addListener(() {
        if (_state != ListState.disposed && _marketSelectionProvider.market != null && _marketSelectionProvider.type != null) {
          _getMarketPrices(type: _marketSelectionProvider.type, market: _marketSelectionProvider.market);
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
        return CustomScrollView(
          slivers: [
            MultiSliver(
              children: [
                SliverPinnedHeader(
                  child: MarketListHeader(
                    _pricesProvider.items[0].currency == '' ? 'USD' : _pricesProvider.items[0].currency
                  )
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index){
                    var item = _pricesProvider.items[index];

                    return MarketListCell(
                      item.name, 
                      item.symbol, 
                      item.price.numToString(), 
                      _marketSelectionProvider.type ?? "crypto", 
                      _marketSelectionProvider.market ?? "CoinMarketCap"
                    );
                  },
                  childCount: _pricesProvider.items.length)
                ),
              ],
            ),
          ]
        );
      default:
        return const LoadingView("Loading");
    }
  }
}