import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/add_elevated_button.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/pages/market/markets_page.dart';
import 'package:asset_flutter/content/pages/portfolio/investment_create_page.dart';
import 'package:asset_flutter/content/providers/assets.dart';
import 'package:asset_flutter/content/providers/portfolio/portfolio_state.dart';
import 'package:asset_flutter/content/providers/common/stats_sheet_state.dart';
import 'package:asset_flutter/content/widgets/portfolio/investment_list.dart';
import 'package:asset_flutter/content/widgets/portfolio/portfolio_stats_header.dart';
import 'package:asset_flutter/content/widgets/portfolio/section_sort_title.dart';
import 'package:asset_flutter/content/widgets/portfolio/section_title.dart';
import 'package:asset_flutter/static/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage();
  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  ListState _state = ListState.init;
  String sort = "name";
  int sortType = -1;
  String? _error;
  late final AssetsProvider _assetsProvider;
  late final PortfolioRefreshProvider _refreshListener;
  late final PortfolioStateProvider _stateListener;
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

  void _pageStateListener() {
    if (_state != ListState.disposed && _stateListener.state != null) {
      _error = _stateListener.error;
      setState(() {
        _state = _stateListener.state!;
      });
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
  void initState() {
    _stateListener = PortfolioStateProvider();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      _assetsProvider = Provider.of<AssetsProvider>(context);
      _getAssets();

      _refreshListener = Provider.of<PortfolioRefreshProvider>(context);
      _refreshListener.addListener(_refreshStateListener);

      // _stateListener = Provider.of<PortfolioStateProvider>(context);
      _stateListener.addListener(_pageStateListener);

      _statsSheetProvider = Provider.of<StatsSheetSelectionStateProvider>(context);
      _statsSheetProvider.addListener(_statsSheetListener);
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
        body: ChangeNotifierProvider.value(
          value: _stateListener,
          child: SafeArea(
            child: MediaQuery.of(context).orientation == Orientation.portrait || Platform.isMacOS || Platform.isWindows 
              ? _portraitBody()
              : _landscapeBody()
            ),
        ),
      ),
    );
  }

  Widget _portraitBody() {
    switch (_state) {
      case ListState.loading:
        return const LoadingView("Getting portfolio");
      case ListState.error:
        return ErrorView(_error ?? "Unknown error!", _getAssets);
      case ListState.empty:
      case ListState.done:
        return NestedScrollView(
          floatHeaderSlivers: false,
          headerSliverBuilder: ((context, innerBoxIsScrolled) => [
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height > 600 ? 383 : 363,
                floating: true,
                snap: false,
                backgroundColor: Theme.of(context).backgroundColor,
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
                  ? SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      children: const[
                        SectionTitle("Investments", ""),
                        NoItemView("Couldn't find investment.")
                      ]),
                  )
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 11,
                        child: AddElevatedButton("Add Investment", (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: ((context) => const InvestmentCreatePage()))
                            );
                          },
                        )
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: Platform.isIOS || Platform.isMacOS
                          ? CupertinoButton.filled(
                            child: const ImageIcon(AssetImage("assets/images/markets.png"), color: Colors.white),
                            padding: const EdgeInsets.all(12),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const MarketsPage())
                            ),
                          )
                          : ElevatedButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const MarketsPage())
                            ),
                            child: const ImageIcon(AssetImage("assets/images/markets.png"), color: Colors.white),
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
                )
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
        return const LoadingView("Getting portfolio");
      case ListState.error:
        return ErrorView(_error ?? "Unknown error!", _getAssets);
      case ListState.empty:
      case ListState.done:
        return CustomScrollView(
          physics: const ScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
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
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 11,
                            child: AddElevatedButton("Add Investment", (){
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: ((context) => const InvestmentCreatePage()))
                                );
                              },
                            )
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: Platform.isIOS || Platform.isMacOS
                              ? CupertinoButton.filled(
                                child: const ImageIcon(AssetImage("assets/images/markets.png"), color: Colors.white),
                                padding: const EdgeInsets.all(12),
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const MarketsPage())
                                ),
                              )
                              : ElevatedButton(
                                onPressed: () => showModalBottomSheet(
                                  context: context, 
                                  builder: (_) => Container()
                                ),
                                child: const ImageIcon(AssetImage("assets/images/markets.png"), color: Colors.white),
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
          ],
        );
      default:
        return const LoadingView("Loading");
    }
  }
}