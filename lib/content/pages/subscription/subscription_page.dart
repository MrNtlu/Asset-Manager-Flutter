import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/add_elevated_button.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/pages/subscription/subscription_create_page.dart';
import 'package:asset_flutter/content/providers/common/stats_sheet_state.dart';
import 'package:asset_flutter/content/providers/subscription/subscription_state.dart';
import 'package:asset_flutter/content/providers/subscription/subscriptions.dart';
import 'package:asset_flutter/content/widgets/portfolio/section_sort_title.dart';
import 'package:asset_flutter/content/widgets/portfolio/section_title.dart';
import 'package:asset_flutter/content/widgets/subscription/currency_bar.dart';
import 'package:asset_flutter/content/widgets/subscription/subscription_list.dart';
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

  Future<void> _onRefresh(BuildContext ctx) async {
    _getSubscriptions();
  }

  @override
  void dispose() {
    _state = ListState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      _subscriptionsProvider = Provider.of<SubscriptionsProvider>(context);
      _getSubscriptions();

      _subscriptionStateProvider = Provider.of<SubscriptionStateProvider>(context);
      _subscriptionStateProvider.addListener(() {
        if (_state != ListState.disposed && _subscriptionStateProvider.shouldRefresh) {
          _getSubscriptions();
        }
      });

      _statsSheetProvider = Provider.of<StatsSheetSelectionStateProvider>(context);
      _statsSheetProvider.addListener(() {      
        if (_state != ListState.disposed && _statsSheetProvider.sort != null) {
          sort = _statsSheetProvider.sort!.toLowerCase();
          sortType = _statsSheetProvider.sortType! == "Ascending" ? 1 : -1;
          _getSubscriptions();
        }
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MediaQuery.of(context).orientation == Orientation.portrait || Platform.isMacOS || Platform.isWindows
      ? _portraitBody()
      : _landscapeBody()
    );
  }

  Widget _portraitBody() {
    switch (_state) {
      case ListState.loading:
        return const LoadingView("Fetching subscriptions");
      case ListState.error:
        return ErrorView(_error ?? "Unknown error!", _getSubscriptions);
      case ListState.empty:
      case ListState.done:
        return NestedScrollView(
          floatHeaderSlivers: false,
          headerSliverBuilder: ((context, innerBoxIsScrolled) => [
              const SliverAppBar(
                expandedHeight: 210,
                floating: true,
                snap: false,
                backgroundColor: Colors.white,
                elevation: 5,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Center(
                    child: SubscriptionCurrencyBar(),
                  ),
                ),
              ),
            ]
          ),
          body: RefreshIndicator(
            onRefresh: () => _onRefresh(context),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  _state == ListState.empty
                    ? Column(
                      children: const [
                        SectionTitle("Investments", ""),
                        NoItemView("Couldn't find subscription.")
                      ])
                    : SizedBox(
                        child: Column(
                          children: [
                            SectionSortTitle(
                              "Subscriptions",
                              const ["Name", "Currency", "Price"],
                              const ["Ascending", "Descending"],
                              sortTitle: sort,
                              sortType: sortType,
                            ),
                            const SubscriptionList(),
                          ],
                        )
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
            ),
          ),
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
        return RefreshIndicator(
          onRefresh: () => _onRefresh(context),
          child: CustomScrollView(
            physics: const ScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: Column(
                    children: [
                      const SubscriptionCurrencyBar(),
                      _state == ListState.empty
                        ? Column(
                          children: const [
                            SectionTitle("Investments", ""),
                            NoItemView("Couldn't find subscription.")
                          ])
                        : SizedBox(
                          child: Column(
                            children: [
                              SectionSortTitle(
                                "Subscriptions",
                                const ["Name", "Currency", "Price"],
                                const ["Ascending", "Descending"],
                                sortTitle: sort,
                                sortType: sortType,
                              ),
                              const SubscriptionList(),
                            ],
                          )
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
          ),
        );
      default:
        return const LoadingView("Loading");
    }
  }
}