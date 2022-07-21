import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/content/pages/portfolio/watchlist_edit_page.dart';
import 'package:asset_flutter/content/providers/portfolio/portfolio_state.dart';
import 'package:asset_flutter/content/providers/portfolio/watchlist.dart';
import 'package:asset_flutter/content/widgets/portfolio/watchlist_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistHeader extends StatefulWidget {
  const WatchlistHeader({Key? key}) : super(key: key);

  @override
  State<WatchlistHeader> createState() => _WatchlistHeaderState();
}

class _WatchlistHeaderState extends State<WatchlistHeader> {
  ListState _state = ListState.init;
  String? _error;

  late final WatchListProvider _watchlistProvider;
  late final PortfolioWatchlistRefreshProvider _watchlistRefreshListener;

  void _getWatchlist() {
    setState(() {
      _state = ListState.loading;
    });

    _watchlistProvider.getWatchlist().then((response){
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

  void _watchlistRefreshStateListener() {
    if (_state != ListState.disposed && _watchlistRefreshListener.shouldRefresh) {
      _getWatchlist();
    } 
  }

  @override
  void dispose() {
    _watchlistRefreshListener.removeListener(_watchlistRefreshStateListener);
    _state = ListState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      _watchlistProvider = Provider.of<WatchListProvider>(context);
      _getWatchlist();

      _watchlistRefreshListener = Provider.of<PortfolioWatchlistRefreshProvider>(context);
      _watchlistRefreshListener.addListener(_watchlistRefreshStateListener);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Expanded(
                flex: 7,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      "Watchlist",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: TextButton(
                      child: Text(_watchlistProvider.items.isNotEmpty ? "Edit" : "Hide"),
                      onPressed: () {
                        if (_state == ListState.done || _state == ListState.empty) {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: ((context) => const WatchlistEditPage()))
                          );
                        }
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
          Container(
            height: 140,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.centerLeft,
            child: _portraitBody(),
          ),
        ],
      ),
    );

  }

  Widget _portraitBody() {
    switch (_state) {
      case ListState.loading:
        return const LoadingView("Getting Watchlist");
      case ListState.error:
        return ErrorView(_error ?? "Unknown error!", _getWatchlist);
      case ListState.empty:
      case ListState.done:
        return const WatchlistList();
      default:
        return const LoadingView("Loading");
    }
  }
}