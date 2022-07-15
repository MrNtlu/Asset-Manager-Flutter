import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/add_elevated_button.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/pages/subscription/subscription_create_page.dart';
import 'package:asset_flutter/content/pages/subscription/subscription_details_page.dart';
import 'package:asset_flutter/content/providers/common/stats_sheet_state.dart';
import 'package:asset_flutter/content/providers/subscription/cards.dart';
import 'package:asset_flutter/content/providers/subscription/subscription_state.dart';
import 'package:asset_flutter/content/providers/subscription/subscriptions.dart';
import 'package:asset_flutter/content/widgets/subscription/subscription_list.dart';
import 'package:asset_flutter/content/widgets/subscription/subscription_sheet.dart';
import 'package:asset_flutter/static/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SubscriptionPage extends StatefulWidget {
  final String? notificationId;

  const SubscriptionPage({this.notificationId});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  late ListState _state;
  String sort = "date";
  int sortType = -1;
  String? _error;
  late final SubscriptionsProvider _subscriptionsProvider;
  late final StatsSheetSelectionStateProvider _statsSheetProvider;
  late final SubscriptionRefreshProvider _subscriptionRefreshProvider;
  late final SubscriptionStateProvider _stateListener;

  void _getSubscriptions(){
    setState(() {
      _state = ListState.loading;
    });
    
    _subscriptionsProvider.getSubscriptions(sort: sort, type: sortType).then((response){
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

        if (
          widget.notificationId != null && 
          _subscriptionsProvider.items.indexWhere((element) => element.id == widget.notificationId) != -1
        ) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: ((context) => SubscriptionDetailsPage(widget.notificationId!, isCardDetails: false)))
          );
        }
      }
    });
  }

  void _subscriptionRefreshListener() {
    if (_state != ListState.disposed && _subscriptionRefreshProvider.shouldRefresh) {
      _getSubscriptions();
    }
  }

  void _subscriptionStateListener() {
    if (_state != ListState.disposed && _stateListener.state != null) {
      _error = _stateListener.error;
      setState(() {
        _state = _stateListener.state!;
      });
    }
  }

  void _statsSheetListener() {
    if (_state != ListState.disposed && _statsSheetProvider.sort != null) {
      sort = _statsSheetProvider.sort!.toLowerCase();
      sortType = _statsSheetProvider.sortType! == "Ascending" ? -1 : 1;
      _getSubscriptions();
    }
  }

  @override
  void initState() {
    _state = ListState.init;
    super.initState();
  }

  @override
  void dispose() {
    _subscriptionRefreshProvider.removeListener(_subscriptionRefreshListener);
    _statsSheetProvider.removeListener(_statsSheetListener);
    _stateListener.removeListener(_subscriptionStateListener);
    _state = ListState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      _subscriptionsProvider = Provider.of<SubscriptionsProvider>(context);

      _subscriptionRefreshProvider = Provider.of<SubscriptionRefreshProvider>(context);
      _subscriptionRefreshProvider.addListener(_subscriptionRefreshListener);

      _statsSheetProvider = Provider.of<StatsSheetSelectionStateProvider>(context);
      _statsSheetProvider.addListener(_statsSheetListener);

      _stateListener = Provider.of<SubscriptionStateProvider>(context);
      _stateListener.addListener(_subscriptionStateListener);

      _state = ListState.loading;
      Provider.of<CardProvider>(context).getCreditCards().whenComplete(() {
        if (_state != ListState.disposed) {
          _getSubscriptions();
        }
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarIconBrightness: SharedPref().isDarkTheme() ? Brightness.light : Brightness.dark,
        statusBarBrightness: SharedPref().isDarkTheme() ? Brightness.dark : Brightness.light
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: MediaQuery.of(context).orientation == Orientation.portrait || Platform.isMacOS || Platform.isWindows
          ? _portraitBody()
          : _landscapeBody()
        ),
      ),
    );
  }

  Widget _portraitBody() {
    switch (_state) {
      case ListState.loading:
        return const LoadingView("Getting subscriptions");
      case ListState.error:
        return ErrorView(_error ?? "Unknown error!", _getSubscriptions);
      case ListState.empty:
      case ListState.done:
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              _state == ListState.empty
                ? const Center(child: NoItemView("Couldn't find subscription."))
                : const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: SubscriptionList(),
                ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                      flex: 10,
                      child: AddElevatedButton("Add Subscription", (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SubscriptionCreatePage()));
                        },
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: Platform.isIOS || Platform.isMacOS
                        ? CupertinoButton.filled(
                          child: const Icon(Icons.more_horiz_rounded, color: Colors.white),
                          padding: const EdgeInsets.all(12),
                          onPressed: () => showModalBottomSheet(
                            context: context, 
                            builder: (_) => SubscriptionSheet(_subscriptionsProvider.stats, sort, sortType)
                          ),
                        )
                        : ElevatedButton(
                          onPressed: () => showModalBottomSheet(
                            context: context, 
                            builder: (_) => SubscriptionSheet(_subscriptionsProvider.stats, sort, sortType)
                          ),
                          child: const Icon(Icons.menu_rounded, color: Colors.white),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                            ),
                          ),
                        )
                      ),
                    )
                  ],
                ),
              ),
            ]
          )
        );
      default:
        return const LoadingView("Loading");
    }
  }

  Widget _landscapeBody() {
    switch (_state) {
      case ListState.loading:
        return const LoadingView("Getting subscriptions");
      case ListState.error:
        return ErrorView(_error ?? "Unknown error!", _getSubscriptions);
      case ListState.empty:
      case ListState.done:
        return CustomScrollView(
          physics: const ScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Center(
                child: Column(
                  children: [
                    _state == ListState.empty
                      ? const Center(child: NoItemView("Couldn't find subscription."))
                      : const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: SubscriptionList()
                      ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 10,
                            child: AddElevatedButton("Add Subscription", (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SubscriptionCreatePage()));
                              },
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: Platform.isIOS || Platform.isMacOS
                              ? CupertinoButton.filled(
                                child: const Icon(Icons.more_horiz_rounded, color: Colors.white),
                                padding: const EdgeInsets.all(12),
                                onPressed: () => showModalBottomSheet(
                                  context: context, 
                                  builder: (_) => SubscriptionSheet(_subscriptionsProvider.stats, sort, sortType)
                                ),
                              )
                              : ElevatedButton(
                                onPressed: () => showModalBottomSheet(
                                  context: context, 
                                  builder: (_) => SubscriptionSheet(_subscriptionsProvider.stats, sort, sortType)
                                ),
                                child: const Icon(Icons.menu_rounded),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)
                                  ),
                                ),
                              )
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]
        );
      default:
        return const LoadingView("Loading");
    }
  }
}