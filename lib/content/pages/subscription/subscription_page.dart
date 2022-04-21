import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/add_elevated_button.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/common/widgets/sort_sheet.dart';
import 'package:asset_flutter/content/pages/subscription/card_page.dart';
import 'package:asset_flutter/content/pages/subscription/subscription_create_page.dart';
import 'package:asset_flutter/content/providers/common/stats_sheet_state.dart';
import 'package:asset_flutter/content/providers/subscription/subscription_state.dart';
import 'package:asset_flutter/content/providers/subscription/subscriptions.dart';
import 'package:asset_flutter/content/widgets/subscription/subscription_list.dart';
import 'package:asset_flutter/content/widgets/subscription/subscription_stats_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  ListState _state = ListState.init;
  String sort = "name";
  int sortType = 1;
  String? _error;
  late final SubscriptionsProvider _subscriptionsProvider;
  late final StatsSheetSelectionStateProvider _statsSheetProvider;
  late final SubscriptionStateProvider _subscriptionStateProvider;

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
      }
    });
  }

  void _subscriptionStateListener() {
    if (_state != ListState.disposed && _subscriptionStateProvider.shouldRefresh) {
      _getSubscriptions();
    }
  }

  void _statsSheetListener() {
    if (_state != ListState.disposed && _statsSheetProvider.sort != null) {
      sort = _statsSheetProvider.sort!.toLowerCase();
      sortType = _statsSheetProvider.sortType! == "Ascending" ? 1 : -1;
      _getSubscriptions();
    }
  }

  @override
  void dispose() {
    _subscriptionStateProvider.removeListener(_subscriptionStateListener);
    _statsSheetProvider.removeListener(_statsSheetListener);
    _state = ListState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      _subscriptionsProvider = Provider.of<SubscriptionsProvider>(context);
      _getSubscriptions();

      _subscriptionStateProvider = Provider.of<SubscriptionStateProvider>(context);
      _subscriptionStateProvider.addListener(_subscriptionStateListener);

      _statsSheetProvider = Provider.of<StatsSheetSelectionStateProvider>(context);
      _statsSheetProvider.addListener(_statsSheetListener);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          "Subscriptions", 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.white,
        actions: _iconButtons(),
      ),
      body: SafeArea(
        child: MediaQuery.of(context).orientation == Orientation.portrait || Platform.isMacOS || Platform.isWindows
        ? _portraitBody()
        : _landscapeBody()
      ),
    );
  }

  List<Widget> _iconButtons() {
    return [
      IconButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          shape: Platform.isIOS || Platform.isMacOS
          ? const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              topLeft: Radius.circular(16)
            ),
          )
          : null,
          enableDrag: true,
          isDismissible: true,
          builder: (_) => SubscriptionStatsSheet(_subscriptionsProvider.stats)
        ),
        icon: const Icon(Icons.bar_chart_rounded, color: Colors.black),
        tooltip: 'Statistics',
      ),
      IconButton(
        icon: const Icon(Icons.credit_card_rounded, color: Colors.black),
        tooltip: 'Credit Cards',
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const CardPage()) 
        ),
      ),
      IconButton(
        icon: const Icon(Icons.filter_alt_rounded, color: Colors.black),
        tooltip: 'Sort',
        onPressed: () => showModalBottomSheet(
          context: context,
          shape: Platform.isIOS || Platform.isMacOS
          ? const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              topLeft: Radius.circular(16)
            ),
          )
          : null,
          enableDrag: false,
          isDismissible: true,
          isScrollControlled: true,
          builder: (_) => SortSheet(
            const ["Name", "Currency", "Price"],
            const ["Ascending", "Descending"],
            selectedSort: const ["Name", "Currency", "Price"].indexOf("${sort[0].toUpperCase()}${sort.substring(1)}"),
            selectedSortType: sortType == 1 ? 0 : 1,
          )
        ),
      )
    ];
  }

  Widget _portraitBody() {
    switch (_state) {
      case ListState.loading:
        return const LoadingView("Fetching subscriptions");
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
              Container(
                alignment: Alignment.bottomCenter,
                child: AddElevatedButton("Add Subscription", (){
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: ((context) => SubscriptionCreatePage()))
                  );
                },
                edgeInsets: const EdgeInsets.only(left: 8, right: 8, bottom: 8)),
              ),
          ])
        );
      default:
        return const LoadingView("Loading");
    }
  }

  Widget _landscapeBody() {
    switch (_state) {
      case ListState.loading:
        return const LoadingView("Fetching subscriptions");
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
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: AddElevatedButton("Add Subscription", (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: ((context) => SubscriptionCreatePage()))
                        );
                      },
                      edgeInsets: const EdgeInsets.all(8)),
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