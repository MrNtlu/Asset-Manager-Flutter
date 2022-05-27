import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/models/requests/transaction.dart';
import 'package:asset_flutter/content/providers/wallet/transaction_date_state.dart';
import 'package:asset_flutter/content/providers/wallet/transaction_sheet_state.dart';
import 'package:asset_flutter/content/providers/wallet/transactions.dart';
import 'package:asset_flutter/content/widgets/wallet/tl_cell.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({Key? key}) : super(key: key);

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  ListState _state = ListState.init;
  late final ScrollController _scrollController;
  late final TransactionsProvider _provider;
  late final TransactionSheetSelectionStateProvider _selectionProvider;
  final TransactionSortFilter _sortFilter = TransactionSortFilter(1, "date", -1);
  int _page = 1;
  bool _canPaginate = false;
  bool _isPaginating = false;
  String? _error;
  
  void _getTransactions() {
    if (_page == 1) {
      setState(() {
        _state = ListState.loading;  
      });
    } else {
      _canPaginate = false;
      _isPaginating = true;
    }

    _provider.getTransactions(sortFilter: _sortFilter).then((response) {
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
      _getTransactions();
    }
  }

  void onSelectionListener() {
    _sortFilter.bankAccID = _selectionProvider.selectedBankAcc?.id;
    _sortFilter.cardID = _selectionProvider.selectedCard?.id;
    _sortFilter.category = _selectionProvider.selectedCategory?.value.toString();
    _sortFilter.startDate = _selectionProvider.selectedTimeRange != null ? DateUtils.dateOnly(_selectionProvider.selectedTimeRange!.start): null;
    _sortFilter.endDate = _selectionProvider.selectedTimeRange != null ? DateUtils.dateOnly(_selectionProvider.selectedTimeRange!.end): null;
    _sortFilter.sort = _selectionProvider.sort != null ? _selectionProvider.sort!.toLowerCase() : "date";
    _sortFilter.sortType = _selectionProvider.sortType != null 
    ? (_selectionProvider.sortType! == "Ascending" ? 1 : -1)
    : -1;
    _sortFilter.page = 1;
    _getTransactions();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollHandler);
    _selectionProvider.removeListener(onSelectionListener);
    _state = ListState.disposed;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      _provider = Provider.of<TransactionsProvider>(context);
      _selectionProvider = Provider.of<TransactionSheetSelectionStateProvider>(context);
      _selectionProvider.addListener(onSelectionListener);
      _scrollController = ScrollController();
      _scrollController.addListener(_scrollHandler);

      final _selectedTimeRangeProvider = Provider.of<TransactionDateRangeSelectionStateProvider>(context, listen: false);
      if  (_selectedTimeRangeProvider.selectedTimeRange != null) {
        _sortFilter.startDate = _selectedTimeRangeProvider.selectedTimeRange!.start;
        _sortFilter.endDate = _selectedTimeRangeProvider.selectedTimeRange!.end;
        _selectionProvider.selectedTimeRange = _selectedTimeRangeProvider.selectedTimeRange;
        _selectedTimeRangeProvider.selectedTimeRange = null;
      }

      _getTransactions();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case ListState.done:
        final _data = _provider.items;

        return ListView.separated(
          controller: _scrollController,
          itemBuilder: (ctx, index) {
            if ((_canPaginate || _isPaginating) && index == _data.length) {
              return Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  height: 45,
                  width: 45,
                  child: const CircularProgressIndicator(),
                ),
              );
            } else if (index == _data.length + ((_canPaginate || _isPaginating) ? 1 : 0)) {
              return const SizedBox(height: 75);
            }
            
            //TODO: Test pagination, change design
            final data = _data[index];
            if (_sortFilter.sort == "date" && (index == 0 || (index != 0 && !isSameDay(data.transactionDate, _data[index - 1].transactionDate)))){
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      data.transactionDate.dateToHumanDate(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      ),
                    ),
                  ),
                  const Divider(),
                  TransactionListCell(data)
                ],
              );
            }
            return TransactionListCell(data);
          },
          separatorBuilder: (_, __) => const Divider(),
          itemCount:_data.length + (_canPaginate ? 2 : 1),
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
        );
      case ListState.empty:
        var noItemView = const NoItemView("No transaction yet.");
        return Center(
          child: noItemView
        );
      case ListState.error:
        var errorView = ErrorView(_error ?? "Unknown error!", _getTransactions);
        return Center(
          child: errorView
        );
      case ListState.loading:
        return const LoadingView("Getting transactions");
      default:
        return const LoadingView("Loading");
    }
  }
}