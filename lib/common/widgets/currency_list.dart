import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/currency_list_cell.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/models/responses/investings.dart';
import 'package:asset_flutter/content/providers/common/currencies.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore_for_file: must_be_immutable
class CurrencyList extends StatefulWidget {
  String selectedSymbol;
  
  CurrencyList(this.selectedSymbol, {Key? key}) : super(key: key);

  @override
  State<CurrencyList> createState() => _CurrencyListState();
}

class _CurrencyListState extends State<CurrencyList> {
  ListState _state = ListState.init;
  String? _error;
  late final List<bool> _selectionList = [];
  late final CurrenciesProvider _provider;
  late final ScrollController _scrollController;
  late bool isPortraitOrDesktop;

  void _getCurrencyList() {
    setState(() {
      _state = ListState.loading;  
    });

    _provider.getMarketPrices().then((response){
      if (_state != ListState.disposed) {
        final _data = response.data;
        for (var i = 0; i < _data.length; i++) {
          _selectionList.insert(i, _data[i] == Investings("", widget.selectedSymbol) ? true : false);
          if (_data[i] == Investings("", widget.selectedSymbol)) {
            _scrollController = ScrollController(initialScrollOffset: i * 72);
          }
        }

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

  @override
  void dispose() {
    _state = ListState.disposed;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      _provider = Provider.of<CurrenciesProvider>(context);
      _getCurrencyList();
    }
    isPortraitOrDesktop = MediaQuery.of(context).orientation == Orientation.portrait 
      || Platform.isMacOS 
      || Platform.isWindows;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    switch (_state) {
      case ListState.done:
        return ListView.separated(
          controller: _scrollController,
          itemBuilder: ((context, index) {
            final data = _provider.items[index];
            final currencySelection = _selectionList[index];

            return CurrencyListCell("${data.name}/${data.symbol}", currencySelection, index, handleSelection);
          }),
          separatorBuilder: (_, __) => const Divider(), 
          shrinkWrap: true,
          itemCount: _provider.items.length,
        );
      case ListState.empty:
        var noItemView = const NoItemView("Couldn't find any currency.");
        return isPortraitOrDesktop
          ? noItemView
          : SingleChildScrollView(
            child: noItemView,
          );
      case ListState.error:
        var errorView = ErrorView(_error ?? "Unknown error!", _getCurrencyList);
        return isPortraitOrDesktop 
          ? errorView
          : SingleChildScrollView(
            child: errorView,
          );
      case ListState.loading:
        return const LoadingView("Fetching currencies");
      default:
        return const LoadingView("Loading");
    }
  }

  void handleSelection(int index) {
    for (var i = 0; i < _selectionList.length; i++) {
      if (index != i) {
        _selectionList[i] = false;
      }
    }

    setState(() {
      widget.selectedSymbol = _provider.items[index].symbol;
      _selectionList[index] = true;
    });
  }
}