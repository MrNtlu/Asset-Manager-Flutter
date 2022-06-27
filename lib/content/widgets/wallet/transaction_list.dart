import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/models/requests/transaction.dart';
import 'package:asset_flutter/content/providers/subscription/cards.dart';
import 'package:asset_flutter/content/providers/wallet/bank_accounts.dart';
import 'package:asset_flutter/content/providers/wallet/transaction_sheet_state.dart';
import 'package:asset_flutter/content/providers/wallet/transaction_state.dart';
import 'package:asset_flutter/content/providers/wallet/transactions.dart';
import 'package:asset_flutter/content/providers/wallet/wallet_state.dart';
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
  late ListState _state;
  late final ScrollController _scrollController;
  late final TransactionsProvider _provider;
  late final TransactionStateProvider _transactionsStateProvider;
  late final TransactionSheetSelectionStateProvider _selectionProvider;
  late final WalletStateProvider _walletStateProvider;
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

  void _transactionStateListener() {
    if (_state != ListState.disposed && _transactionsStateProvider.shouldRefresh) {
      _getTransactions();
    }
  }

  void _walletStateListener() {
    if (_state != ListState.disposed) {
      if (_state == ListState.done) {
        _getTransactions();
      } else {
        setState(() {
          _state = _walletStateProvider.state;
        });
      }
    }
  }

  @override
  void dispose() {
    _state = ListState.disposed;
    _transactionsStateProvider.removeListener(_transactionStateListener);
    _scrollController.removeListener(_scrollHandler);
    _selectionProvider.removeListener(onSelectionListener);
    _walletStateProvider.removeListener(_walletStateListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _state = ListState.init;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      _provider = Provider.of<TransactionsProvider>(context);
      
      _transactionsStateProvider = Provider.of<TransactionStateProvider>(context);
      _transactionsStateProvider.addListener(_transactionStateListener);
      _selectionProvider = Provider.of<TransactionSheetSelectionStateProvider>(context);
      _selectionProvider.addListener(onSelectionListener);
      _scrollController = ScrollController();
      _scrollController.addListener(_scrollHandler);
      _walletStateProvider = Provider.of<WalletStateProvider>(context);
      _walletStateProvider.addListener(_walletStateListener);

      _state = ListState.loading;
      Future.wait([
        Provider.of<CardProvider>(context).getCreditCards(),
        Provider.of<BankAccountProvider>(context).getBankAccounts()
      ]).whenComplete(() => {
        if (_state != ListState.disposed) {
          _getTransactions()
        }
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case ListState.done:
        final _data = _provider.items;

        return ListView.builder(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                    child: Text(
                      data.transactionDate.dateToInfoDate(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
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