import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/add_elevated_button.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/pages/market/markets_page.dart';
import 'package:asset_flutter/content/pages/portfolio/ic_type_page.dart';
import 'package:asset_flutter/content/pages/portfolio/portfolio_stats_page.dart';
import 'package:asset_flutter/content/providers/assets.dart';
import 'package:asset_flutter/content/providers/portfolio/portfolio_filter.dart';
import 'package:asset_flutter/content/providers/portfolio/portfolio_state.dart';
import 'package:asset_flutter/content/providers/common/stats_sheet_state.dart';
import 'package:asset_flutter/content/widgets/portfolio/investment_filter_list.dart';
import 'package:asset_flutter/content/widgets/portfolio/investment_list.dart';
import 'package:asset_flutter/content/widgets/portfolio/portfolio_stats_header.dart';
import 'package:asset_flutter/content/widgets/portfolio/section_sort_title.dart';
import 'package:asset_flutter/content/widgets/portfolio/section_title.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
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
  late final PortfolioFilterProvider _filterListener;
  late final StatsSheetSelectionStateProvider _statsSheetProvider;

  void _getAssets() {
    setState(() {
      _state = ListState.loading;
    });

    _assetsProvider.getAssets(sort: sort, type: sortType, assetTypes: _filterListener.filterList).then((response){
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

  void _filterSelectionListener() {
    if (_state != ListState.disposed) {
      _getAssets();
    }
  }

  @override
  void dispose() {
    _refreshListener.removeListener(_refreshStateListener);
    _statsSheetProvider.removeListener(_statsSheetListener);
    _stateListener.removeListener(_pageStateListener);
    _filterListener.removeListener(_filterSelectionListener);
    _state = ListState.disposed;
    super.dispose();
  }

  @override
  void initState() {
    _stateListener = PortfolioStateProvider();
    _filterListener = PortfolioFilterProvider();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      _assetsProvider = Provider.of<AssetsProvider>(context);
      _getAssets();

      _refreshListener = Provider.of<PortfolioRefreshProvider>(context);
      _refreshListener.addListener(_refreshStateListener);

      _stateListener.addListener(_pageStateListener);
      _filterListener.addListener(_filterSelectionListener);

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
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: _stateListener),
            ChangeNotifierProvider.value(value: _filterListener)
          ],
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
                expandedHeight: SharedPref().getIsWatchlistHidden() ? 165 : 373,
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
                      children: [
                        const SectionTitle("Investments", ""),
                        const InvestmentFilterList(),
                        if(!SharedPref().getIsIntroductionDeleted())
                        _introductionCell()
                        else
                        const NoItemView("Couldn't find investment.")
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
                        const InvestmentFilterList(),
                        if(!SharedPref().getIsIntroductionDeleted())
                        _introductionCell(),
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
                              MaterialPageRoute(builder: ((context) => const InvestmentCreateTypePage()))
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
                            child: const Icon(Icons.bar_chart_rounded, color: Colors.white),
                            padding: const EdgeInsets.all(12),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const PortfolioStatsPage())
                            ),
                          )
                          : ElevatedButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const PortfolioStatsPage())
                            ),
                            child: const Icon(Icons.bar_chart_rounded, color: Colors.white),
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
                      ]
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
                                  MaterialPageRoute(builder: ((context) => const InvestmentCreateTypePage()))
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

  Widget _introductionCell() => Column(
    children: [
      Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (slideContext) {
                setState(() {
                  SharedPref().setIsIntroductionDeleted(true);
                });
                showDialog(
                  context: context, 
                  builder: (_) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: AppColors().lightBlack,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset(
                          "assets/lottie/swipe.json",
                          frameRate: FrameRate(60),
                          height: 150,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(6),
                          child: Text(
                            "You can always delete or edit by swiping left.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("OK")
                        )
                      ],
                    ),
                  ),
                );
              },
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.red,
              icon: Icons.delete_rounded,
              label: 'Delete',
            ),
          ],
        ),
        child: ListTile(
          title: Row(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                padding: const EdgeInsets.all(0.2),
                decoration: BoxDecoration(
                    color: const Color(0x40000000), borderRadius: BorderRadius.circular(24)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(22),
                    child: Image.asset(
                      "assets/images/investment.png",
                      width: 48,
                      height: 48,
                      fit: BoxFit.contain,
                    )
                  ),
                ),
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    "Swipe to delete",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Icon(
                Icons.swipe_left_rounded,
                color: Theme.of(context).colorScheme.bgTextColor,
              )
            ],
          ),
        ),
      ),
      const Divider()
    ],
  );
}