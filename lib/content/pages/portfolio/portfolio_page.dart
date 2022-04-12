import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/common/widgets/sort_list.dart';
import 'package:asset_flutter/common/widgets/sort_toggle.dart';
import 'package:asset_flutter/content/providers/assets.dart';
import 'package:asset_flutter/content/providers/portfolio/portfolio_state.dart';
import 'package:asset_flutter/content/widgets/portfolio/add_investment_button.dart';
import 'package:asset_flutter/content/widgets/portfolio/investment_list.dart';
import 'package:asset_flutter/content/widgets/portfolio/portfolio_stats_header.dart';
import 'package:asset_flutter/content/widgets/portfolio/section_title.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

//TODO: Implement sorting for investments
class PortfolioPage extends StatefulWidget {
  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  ListState _state = ListState.init;
  late final AssetsProvider _assetsProvider;
  String? _error;

  void _getAssets() {
    setState(() {
      _state = ListState.loading;
    });

    _assetsProvider.getAssets().then((response){
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
    _getAssets();
  }

  @override
  void dispose() {
    _state = ListState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      _assetsProvider = Provider.of<AssetsProvider>(context);
      _getAssets();

      var _refreshListener = Provider.of<PortfolioStateProvider>(context);
      _refreshListener.addListener(() {
        if (_state != ListState.disposed && _refreshListener.shouldRefresh) {
          _getAssets();
        }
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light),
      child: SafeArea(
        child: MediaQuery.of(context).orientation == Orientation.portrait || Platform.isMacOS || Platform.isWindows 
          ? _portraitBody()
          : _landscapeBody()
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
                expandedHeight: MediaQuery.of(context).size.height > 600 ? 420 : 400,
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
          body: RefreshIndicator(
            onRefresh: () => _onRefresh(context),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  _state == ListState.empty
                    ? Column(
                      children: const[
                        SectionTitle("Investments", ""),
                        NoItemView("Couldn't find investment.")
                      ])
                    : Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 6,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      "Investments",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: TextButton(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text("Name"),
                                          Icon(
                                            Icons.arrow_upward_rounded,
                                            size: 16,
                                          )
                                        ],
                                      ),
                                      onPressed: () => showModalBottomSheet(
                                        context: context,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(12),
                                            topLeft: Radius.circular(12)
                                          ),
                                        ),
                                        enableDrag: true,
                                        builder: (_) => Container(
                                          height: 350,
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.only(
                                                topRight: Radius.circular(12),
                                                topLeft: Radius.circular(12)),
                                          ),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 16),
                                              SortToggleButton(),
                                              SizedBox(height: 250, child: SortList(["Name", "Value", "Amount", "Profit"]))
                                            ],
                                          ),
                                        )
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          //const SectionTitle("Investments", ""),
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
            ),
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
        return RefreshIndicator(
          onRefresh: () => _onRefresh(context), 
          child: CustomScrollView(
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
                          : const PortfolioInvestmentList(),
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
          ),
        );
      default:
        return const LoadingView("Loading");
    }
  }
}