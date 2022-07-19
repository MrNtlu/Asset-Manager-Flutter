import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/check_dialog.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/common/widgets/success_view.dart';
import 'package:asset_flutter/content/providers/portfolio/watchlist.dart';
import 'package:asset_flutter/static/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistEditPage extends StatefulWidget {
  const WatchlistEditPage({Key? key}) : super(key: key);

  @override
  State<WatchlistEditPage> createState() => _WatchlistEditPageState();
}

class _WatchlistEditPageState extends State<WatchlistEditPage> {
  ListState _state = ListState.init;
  String? _error;

  late final WatchListProvider _provider;

  void _deleteAllWatchlist() {
    setState(() {
      _state = ListState.loading;
    });

    _provider.deleteAllFavInvestings().then((response) {
      if (_state != ListState.disposed) {
        if (response.error == null) {
          setState(() {
            _state = ListState.empty;
          });
          showDialog(
            barrierDismissible: false,
            barrierColor: Colors.black54,
            context: context,
            builder: (ctx) => const SuccessView("deleted", shouldJustPop: true)
          );
        } else {
          _error = response.error;
          setState(() {
            _state = ListState.error;
          });
        }
      }
    });
  }
  
  void _deleteWatchlistItem(String id) {
    setState(() {
      _state = ListState.loading;
    });

    _provider.deleteFavInvesting(id).then((response) {
      if (_state != ListState.disposed) {
        if (response.error == null) {
          setState(() {
            _state = _provider.items.isNotEmpty ? ListState.done : ListState.empty;
          });
          showDialog(
            barrierDismissible: false,
            barrierColor: Colors.black54,
            context: context,
            builder: (ctx) => const SuccessView("deleted", shouldJustPop: true)
          );
        } else {
          _error = response.error;
          setState(() {
            _state = ListState.error;
          });
        }
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
      _provider = Provider.of<WatchListProvider>(context);

      _state = _provider.items.isNotEmpty ? ListState.done : ListState.empty;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          if(_state == ListState.empty)
          TextButton(
            onPressed: () => Platform.isIOS || Platform.isMacOS
            ? showCupertinoDialog(
              context: context, 
              builder: (ctx) => AreYouSureDialog("hide watchlist section", (){
                Navigator.pop(ctx);
                SharedPref().setIsWatchlistHidden(true);

                showCupertinoDialog(
                  context: context, 
                  barrierDismissible: false,
                  builder: (_) => CupertinoAlertDialog(
                    title: const Text('Section Hidden!'),
                    content: const Text('You can enable watchlist from settings.'),
                    actions: [
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        onPressed: (){
                          Navigator.pushNamedAndRemoveUntil(context, "/tabs", (route) => false);
                        },
                        child: const Text('OK')
                      ),
                    ],
                  )
                );
              })
            )
            : showDialog(
              context: context, 
              builder: (ctx) => AreYouSureDialog("hide watchlist section", (){
                Navigator.pop(ctx);
                SharedPref().setIsWatchlistHidden(true);

                showDialog(
                  context: context, 
                  barrierDismissible: false,
                  builder: (_) => WillPopScope(
                    onWillPop: () async {
                      Navigator.pushNamedAndRemoveUntil(context, "/tabs", (route) => false);

                      return true;
                    },
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                      ),
                      title: const Text('Section Hidden!'),
                      content: const Text('You can enable watchlist from settings.'),
                      actions: [
                        TextButton(
                          onPressed: (){
                            Navigator.pushNamedAndRemoveUntil(context, "/tabs", (route) => false);
                          },
                          child: const Text('OK')
                        ),
                      ],
                    ),
                  )
                );
              })
            ),
            child: const Text(
              "Hide Section",
            )
          ),
          if(_state == ListState.done)
          TextButton(
            onPressed: () => Platform.isIOS || Platform.isMacOS
            ? showCupertinoDialog(
              context: context, 
              builder: (ctx) => AreYouSureDialog("delete all watchlist", (){
                Navigator.pop(ctx);
                _deleteAllWatchlist();
              })
            )
            : showDialog(
              context: context, 
              builder: (ctx) => AreYouSureDialog("delete all watchlist", (){
                Navigator.pop(ctx);
                _deleteAllWatchlist();
              })
            ),
            child: const Text(
              "Delete All",
            )
          )
        ],
        title: const Text(
          "Edit", 
        ),
      ),
      body: SafeArea(
        child: _portraitBody(),
      ),
    );
  }

  Widget _portraitBody() {
    switch (_state) {
      case ListState.loading:
        return const LoadingView("Getting Watchlist");
      case ListState.error:
        return ErrorView(_error ?? "Unknown error!", () {
          setState(() {
            _state = ListState.done;
          });
        });
      case ListState.empty:
        return const Center(child: NoItemView("Watchlist is empty."));
      case ListState.done:
        return ReorderableListView(
          children: <Widget>[
            for (int index = 0; index < _provider.items.length; index++)
            ListTile(
              key: Key('$index'),
              title: Row(
                children: [
                  Expanded(
                    child: Text(_provider.items[index].investingID.symbol)
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                    ),
                    onPressed: () => Platform.isIOS || Platform.isMacOS
                    ? showCupertinoDialog(
                      context: context, 
                      builder: (ctx) => AreYouSureDialog("delete ${_provider.items[index].investingID.symbol}", (){
                        Navigator.pop(ctx);
                        _deleteWatchlistItem(_provider.items[index].id);
                      })
                    )
                    : showDialog(
                      context: context, 
                      builder: (ctx) => AreYouSureDialog("delete ${_provider.items[index].investingID.symbol}", (){
                        Navigator.pop(ctx);
                        _deleteWatchlistItem(_provider.items[index].id);
                      })
                    )
                  )
                ],
              ),
              leading: const Icon(Icons.reorder_rounded),
            )
          ], 
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if(newIndex > oldIndex){
                newIndex -= 1;
              }
              final items = _provider.items.removeAt(oldIndex);
              _provider.items.insert(newIndex, items);
            });
          } 
        );
      default:
        return const LoadingView("Loading");
    }
  }
}