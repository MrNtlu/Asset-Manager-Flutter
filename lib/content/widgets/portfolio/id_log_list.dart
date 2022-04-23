import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/models/responses/asset.dart';
import 'package:asset_flutter/content/providers/asset.dart';
import 'package:asset_flutter/content/providers/asset_logs.dart';
import 'package:asset_flutter/content/widgets/portfolio/id_list_cell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvestmentDetailsLogList extends StatefulWidget {
  final double _appBarHeight;
  final Asset _asset;

  const InvestmentDetailsLogList(this._appBarHeight, this._asset, {Key? key}) : super(key: key);

  @override
  State<InvestmentDetailsLogList> createState() => _InvestmentDetailsLogListState();
}

class _InvestmentDetailsLogListState extends State<InvestmentDetailsLogList> {
  ListState _state = ListState.init;
  late final AssetLogProvider _provider;
  late final ScrollController _scrollController;
  int _page = 1;
  bool _canPaginate = false;
  bool _isPaginating = false;
  String? _error;
  late bool isPortraitOrDesktop;

  void _getAssetLogs() {
    if (_page == 1) {
      setState(() {
        _state = ListState.loading;  
      });
    } else {
      _canPaginate = false;
      _isPaginating = true;
    }

    _provider.getAssetLogs(
      toAsset: widget._asset.toAsset, 
      fromAsset: widget._asset.fromAsset,
      page: _page,
      assetMarket: widget._asset.market
      // sort: 
    ).then((response){
      _error = response.error;
      _canPaginate = response.canNextPage;
      _isPaginating = false;
      if (_state != ListState.disposed) {
        setState(() {
          _state = response.error != null
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

  void _scrollHandler() {
    if (
      _canPaginate 
      && _scrollController.offset >= _scrollController.position.maxScrollExtent / 2
      && !_scrollController.position.outOfRange
    ) {
      _page ++;
      _getAssetLogs();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollHandler);
    _state = ListState.disposed;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
       _provider = Provider.of<AssetLogProvider>(context);
       _scrollController = ScrollController();
       _scrollController.addListener(_scrollHandler);
      _getAssetLogs();
    }
    isPortraitOrDesktop = MediaQuery.of(context).orientation == Orientation.portrait 
      || Platform.isMacOS 
      || Platform.isWindows;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _data = _provider.items;

    return SizedBox(
      height: MediaQuery.of(context).size.height - ( 
            widget._appBarHeight + 
            MediaQuery.of(context).padding.top + 
            MediaQuery.of(context).padding.bottom),
      child: _body(_data)
    );
  }

  Widget _body(List<AssetLog> _data) {
    switch (_state) {
      case ListState.done:
        return ListView.builder(
          controller: _scrollController,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const SizedBox(height: 100);
            } else if ((_canPaginate || _isPaginating) && index == _data.length + 1) {
              return Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  height: 45,
                  width: 45,
                  child: const CircularProgressIndicator(),
                ),
              );
            } else if (index == _data.length + ((_canPaginate || _isPaginating) ? 2 : 1)){
              return const SizedBox(height: 65);
            }

            final data = _data[index - 1];
            return InvestmentDetailsListCell(data);
          },
          itemCount: _data.length + (_canPaginate ? 3 : 2),
          padding: const EdgeInsets.only(top: 4),
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
        );
      case ListState.empty:
        var noItemView = const NoItemView("Couldn't find investment.");
        return Center(
          child: Padding(
            padding: EdgeInsets.only(
              top: isPortraitOrDesktop ? widget._appBarHeight : 95,
              bottom: isPortraitOrDesktop ? 0 : 50
            ),
            child: isPortraitOrDesktop
              ? noItemView
              : SingleChildScrollView(
                child: noItemView,
              ),
          ),
        );
      case ListState.error:
        var errorView = ErrorView(_error ?? "Unknown error!", _getAssetLogs);
        return Center(
          child: Padding(
            padding: EdgeInsets.only(
              top: isPortraitOrDesktop ? 105 : 95,
              bottom: isPortraitOrDesktop ? 0 : 50
            ),
            child: isPortraitOrDesktop 
              ? errorView
              : SingleChildScrollView(
                child: errorView,
              )
          ),
        );
      case ListState.loading:
        return const LoadingView("Fetching investments");
      default:
        return const LoadingView("Loading");
    }
  }
}