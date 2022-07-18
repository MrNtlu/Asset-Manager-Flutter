import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/providers/market/market_selection_state.dart';
import 'package:asset_flutter/content/providers/market/prices.dart';
import 'package:asset_flutter/content/widgets/portfolio/il_cell_image.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/images.dart';
import 'package:asset_flutter/utils/stock_handler.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistSheetList extends StatefulWidget {
  const WatchlistSheetList({Key? key}) : super(key: key);

  @override
  State<WatchlistSheetList> createState() => _WatchlistSheetListState();
}

class _WatchlistSheetListState extends State<WatchlistSheetList> {
  ListState _state = ListState.init;
  String? _error;
  String _search = '';

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

  void _marketSelectionListener() {
    if (_state != ListState.disposed && _marketSelectionProvider.market != null && _marketSelectionProvider.type != null) {
      _getMarketPrices(type: _marketSelectionProvider.type, market: _marketSelectionProvider.market);
    }
  }

  @override
  void dispose() {
    _marketSelectionProvider.type = null;
    _marketSelectionProvider.market = null;
    _marketSelectionProvider.removeListener(_marketSelectionListener);
    _state = ListState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      _pricesProvider = Provider.of<PricesProvider>(context);
      _getMarketPrices();

      _marketSelectionProvider = Provider.of<MarketSelectionStateProvider>(context);
      _marketSelectionProvider.addListener(_marketSelectionListener);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _searchTextController = TextEditingController(text: _search);
    return Expanded(child: _portraitBody());
  }

  Widget _portraitBody() {
    switch (_state) {
      case ListState.loading:
        return const LoadingView("Getting Market Prices");
      case ListState.error:
        return ErrorView(_error ?? "Unknown error!", _getMarketPrices);
      case ListState.empty:
        return const NoItemView("Couldn't find anything.");
      case ListState.done:
        return ListView.separated(
          itemBuilder: (ctx, index) {
            var item = _pricesProvider.items[index];
        
            return GestureDetector(
              onTap: () {
                
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InvestmentListCellImage(
                            _getImageFromType(
                              _marketSelectionProvider.type ?? "crypto",
                              item.symbol,
                              _marketSelectionProvider.market ?? "CoinMarketCap"
                            ), 
                            _marketSelectionProvider.type ?? "crypto",
                            margin: const EdgeInsets.all(0),
                            borderRadius:  BorderRadius.circular(18),
                            size: 18,
                            boxfit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            item.name != item.symbol ? "${item.name}/${item.symbol}" : item.name, 
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }, 
          separatorBuilder: (_, __) => const Divider(thickness: 0.7), 
          itemCount: _pricesProvider.items.length
        );
      default:
        return const LoadingView("Loading");
    }
  }

  void searchInvesting(String search) async {
    _search = search;
  }

  String _getImageFromType(String _type, String _symbol, String _market) {
    if (_type == "crypto") {
      return PlaceholderImages().cryptoImage(_symbol);
    } else if (_type == "stock") {
      return 'icons/flags/png/${convertIndexNameToFlag(_market)}.png';
    } else {
      return 'assets/images/gold.png';
    }
  }
}