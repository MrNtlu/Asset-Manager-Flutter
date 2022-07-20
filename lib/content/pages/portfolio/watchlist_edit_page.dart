import 'dart:convert';
import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/check_dialog.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/common/widgets/success_view.dart';
import 'package:asset_flutter/content/models/requests/favourite_investing.dart';
import 'package:asset_flutter/content/models/responses/favourite_investment.dart';
import 'package:asset_flutter/content/providers/portfolio/watchlist.dart';
import 'package:asset_flutter/content/widgets/portfolio/watchlist_color_sheet.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/shared_pref.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class WatchlistEditPage extends StatefulWidget {
  const WatchlistEditPage({Key? key}) : super(key: key);

  @override
  State<WatchlistEditPage> createState() => _WatchlistEditPageState();
}

class _WatchlistEditPageState extends State<WatchlistEditPage> {
  ListState _state = ListState.init;
  String? _error;
  bool isReorderActive = false;

  final List<FavouriteInvesting> _tempOrderList = [];
  late final WatchListProvider _provider;

  void _updateWatchlistOrder() {
    bool isOrderChanged = false;
    for (var i = 0; i < _tempOrderList.length; i++) {
      if (_tempOrderList[i].id != _provider.items[i].id) {
        isOrderChanged = true;
        break;
      }
    }

    if (!isOrderChanged) {
      setState(() {
        isReorderActive = false;
      });

      return;
    }

    setState(() {
      isReorderActive = false;
      _state = ListState.loading;
    });

    _provider.updateOrder(_tempOrderList);
    _provider.updatePriority();

    try {
      http.put(
        Uri.parse(APIRoutes().favInvestingRoutes.updateFavouriteInvestingOrder),
        body: json.encode({
          "orders": _provider.items.map((e) => FavouriteInvestingOrder(e.id, e.priority).convertToJson()).toList()
        }),
        headers: UserToken().getBearerToken()
      ).then((response){
        if (_state != ListState.disposed) {
          setState(() {
            _state = ListState.done;
          });
          Platform.isIOS || Platform.isMacOS
          ? showCupertinoDialog(
            context: context, 
            builder: (ctx) => const SuccessView("updated watchlist order", shouldJustPop: true)
          )
          : showDialog(
            barrierColor: Colors.black54,
            context: context, 
            builder: (ctx) => const SuccessView("updated watchlist order", shouldJustPop: true)
          );
        }
      });
    } catch(error) {
      _error = error.toString();
      setState(() {
        _state = ListState.error;
      });
    }
  }

  void _deleteAllWatchlist() {
    setState(() {
      isReorderActive = false;
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
              style: TextStyle(fontWeight: FontWeight.bold),
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
              style: TextStyle(fontWeight: FontWeight.bold),
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
        return const LoadingView("Loading");
      case ListState.error:
        return ErrorView(_error ?? "Unknown error!", () {
          setState(() {
            _state = ListState.done;
          });
        });
      case ListState.empty:
        return const Center(child: NoItemView("Watchlist is empty."));
      case ListState.done:
        return Column(
          children: [
            Row(
              children: isReorderActive 
              ? [
                Expanded(
                  child: TextButton(
                    child: const Text("Cancel"),
                    onPressed: (){
                      setState(() {
                        isReorderActive = false;
                      });
                    },
                  )
                ),
                Expanded(
                  child: TextButton(
                    child: const Text("Done"),
                    onPressed: _updateWatchlistOrder,
                  )
                ),
              ]
              : [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.reorder_rounded, 
                      color: Theme.of(context).colorScheme.bgTextColor
                    ),
                    label: Text(
                      "Reorder", 
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.bgTextColor,
                      )
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.bgColor,
                      elevation: 0,
                    ),
                    onPressed: (){
                      _tempOrderList.clear();
                      _tempOrderList.addAll(_provider.items);
                      setState(() {
                        isReorderActive = true;
                      });
                    },
                  )
                ),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.palette_rounded, 
                      color: Theme.of(context).colorScheme.bgTextColor
                    ),
                    label: Text(
                      "Change Color", 
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.bgTextColor,
                      )
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.bgColor,
                      elevation: 0,
                    ),
                    onPressed: (){
                      showModalBottomSheet(
                        context: context, 
                        isDismissible: true,
                        isScrollControlled: false,
                        enableDrag: true,
                        shape: Platform.isIOS || Platform.isMacOS
                        ? const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            topLeft: Radius.circular(16)
                          ),
                        )
                        : null,
                        builder: (_) => const WatchlistColorSheet(),
                      );
                    },
                  )
                ),
              ],
            ),
            Expanded(
              child: ReorderableListView(
                children: <Widget>[
                  for (int index = 0; index < (isReorderActive ? _tempOrderList.length : _provider.items.length); index++)
                  ListTile(
                    key: Key('$index'),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            isReorderActive
                            ? _tempOrderList[index].investingID.symbol
                            : _provider.items[index].investingID.symbol
                          )
                        ),
                        if(!isReorderActive)
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                          onPressed: () => Platform.isIOS || Platform.isMacOS
                          ? showCupertinoDialog(
                            context: context, 
                            builder: (ctx) => AreYouSureDialog("delete ${
                              _provider.items[index].investingID.symbol}", (){
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
                    leading: isReorderActive ? const Icon(Icons.reorder_rounded) : null,
                  )
                ], 
                onReorder: (oldIndex, newIndex) {
                  if(isReorderActive) {
                    setState(() {
                      if(newIndex > oldIndex){
                        newIndex -= 1;
                      }

                      final items = _tempOrderList.removeAt(oldIndex);
                      _tempOrderList.insert(newIndex, items);
                    });
                  }
                } 
              ),
            ),
          ],
        );
      default:
        return const LoadingView("Loading");
    }
  }
}