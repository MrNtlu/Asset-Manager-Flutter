import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/pages/market/markets_page.dart';
import 'package:asset_flutter/content/providers/assets.dart';
import 'package:asset_flutter/content/providers/portfolio/portfolio_state.dart';
import 'package:asset_flutter/content/providers/common/stats_sheet_state.dart';
import 'package:asset_flutter/content/widgets/portfolio/add_investment_button.dart';
import 'package:asset_flutter/content/widgets/portfolio/investment_list.dart';
import 'package:asset_flutter/content/widgets/portfolio/portfolio_stats_header.dart';
import 'package:asset_flutter/content/widgets/portfolio/section_sort_title.dart';
import 'package:asset_flutter/content/widgets/portfolio/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PortfolioPage extends StatefulWidget {
  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  ListState _state = ListState.init;
  String sort = "name";
  int sortType = -1;
  String? _error;
  late final AssetsProvider _assetsProvider;
  late final PortfolioStateProvider _refreshListener;
  late final StatsSheetSelectionStateProvider _statsSheetProvider;

  void _getAssets() {
    setState(() {
      _state = ListState.loading;
    });

    _assetsProvider.getAssets(sort: sort, type: sortType).then((response){
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

  void _statsSheetListener() {
    if (_state != ListState.disposed && _statsSheetProvider.sort != null) {
      if (_statsSheetProvider.sort! == "Profit(%)") {
        sort = "percentage";
      } else {
        sort = _statsSheetProvider.sort!.toLowerCase();
      }
      sortType = _statsSheetProvider.sortType! == "Ascending" ? -1 : 1;
      _getAssets();
    }
  }
  
  void _refreshStateListener() {
    if (_state != ListState.disposed && _refreshListener.shouldRefresh) {
      _getAssets();
    }
  }

  @override
  void dispose() {
    _refreshListener.removeListener(_refreshStateListener);
    _statsSheetProvider.removeListener(_statsSheetListener);
    _state = ListState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      _assetsProvider = Provider.of<AssetsProvider>(context);
      _getAssets();

      _refreshListener = Provider.of<PortfolioStateProvider>(context);
      _refreshListener.addListener(_refreshStateListener);

      _statsSheetProvider = Provider.of<StatsSheetSelectionStateProvider>(context);
      _statsSheetProvider.addListener(_statsSheetListener);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          title: const Text(
            "Your Portfolio",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
          ),
          centerTitle: false,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MarketsPage())
              ),
              icon: const ImageIcon(AssetImage("assets/images/markets.png"))
            )
          ],
        ),
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
        return const LoadingView("Fetching portfolio");
      case ListState.error:
        return ErrorView(_error ?? "Unknown error!", _getAssets);
      case ListState.empty:
      case ListState.done:
        return NestedScrollView(
          floatHeaderSlivers: false,
          headerSliverBuilder: ((context, innerBoxIsScrolled) => [
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height > 600 ? 380 : 360,
                floating: true,
                snap: false,
                backgroundColor: Colors.white,
                elevation: 5,
                flexibleSpace: const FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Center(
                    child: PortfolioStatsHeader(),
                  ),
                ),
              ),
            ]
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                _state == ListState.empty
                  ? Column(
                    children: const[
                      SectionTitle("Investments", ""),
                      NoItemView("Couldn't find investment.")
                    ])
                  : SizedBox(
                    child: Column(
                      children: [
                        SectionSortTitle(
                          "Investments",
                          const ["Name", "Amount", "Profit", "Profit(%)"],
                          const ["Ascending", "Descending"],
                          sortTitle: sort,
                          sortType: sortType,
                        ),
                        const PortfolioInvestmentList(),
                      ],
                    ),
                  ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: const AddInvestmentButton(edgeInsets: EdgeInsets.only(left: 8, right: 8, bottom: 8))
                ),
              ],
            )
          )
        );
      default:
        return const LoadingView("Loading");
    }
  }

  Widget _landscapeBody() {
    switch (_state) {
      case ListState.loading:
        return const LoadingView("Fetching portfolio");
      case ListState.error:
        return ErrorView(_error ?? "Unknown error!", _getAssets);
      case ListState.empty:
      case ListState.done:
        return CustomScrollView(
          physics: const ScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    children: [
                      const PortfolioStatsHeader(),
                      _state == ListState.empty
                        ? Column(
                            children: const[
                              SectionTitle("Investments", ""),
                              NoItemView("Couldn't find investment.")
                            ])
                        : SizedBox(
                            child: Column(
                              children: [
                                SectionSortTitle(
                                  "Investments",
                                  const ["Name", "Amount", "Profit", "Profit(%)"],
                                  const ["Ascending", "Descending"],
                                  sortTitle: sort,
                                  sortType: sortType,
                                ),
                                const PortfolioInvestmentList(),
                              ],
                            )
                          ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: const AddInvestmentButton(edgeInsets: EdgeInsets.all(8))
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      default:
        return const LoadingView("Loading");
    }
  }
}