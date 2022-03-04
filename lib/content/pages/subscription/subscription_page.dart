import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/add_elevated_button.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/pages/subscription/subscription_create_page.dart';
import 'package:asset_flutter/content/providers/subscriptions.dart';
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
  late final SubscriptionsProvider _subscriptionsProvider;
  String? _error;

  void _getSubscriptions(){
    setState(() {
      _state = ListState.loading;
    });
    
    _subscriptionsProvider.getSubscriptions().then((response){
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
                    : const SubscriptionList(),
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
                        : const SubscriptionList(),
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