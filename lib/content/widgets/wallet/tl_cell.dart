import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/check_dialog.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/content/pages/wallet/transaction_create_page.dart';
import 'package:asset_flutter/content/providers/wallet/transaction.dart';
import 'package:asset_flutter/content/providers/wallet/transactions.dart';
import 'package:asset_flutter/content/providers/wallet/wallet_state.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

// ignore_for_file: prefer_const_constructors_in_immutables
class TransactionListCell extends StatelessWidget {
  final Transaction _data;
  late final TransactionsProvider _provider;
  late final WalletStateProvider _walletStateProvider;
  
  TransactionListCell(this._data, {Key? key}) : super(key: key);

  void _deleteTransaction(BuildContext context) {
    _walletStateProvider.setState(ListState.loading);

    _provider.deleteTransaction(_data.id, _data).then((response) {
      if (response.error != null) {
        showDialog(
          context: context, 
          builder: (ctx) => ErrorDialog(response.error!)
        );
      } else {
        _walletStateProvider.setState(ListState.done);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _provider = Provider.of<TransactionsProvider>(context, listen: false);
    _walletStateProvider = Provider.of<WalletStateProvider>(context, listen: false);
    final _isIncome = _data.category == Category.income.value;

    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (slideContext) => showDialog(
              context: context,
              builder: (ctx) => AreYouSureDialog("edit", (){
                Navigator.pop(ctx);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => TransactionCreatePage(false, transactionID: _data.id))
                );
              }),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.orange,
            icon: Icons.edit_rounded,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (context) => showDialog(
              context: context,
              builder: (ctx) => AreYouSureDialog('delete', (){
                Navigator.pop(ctx);
                _deleteTransaction(ctx);
              })
            ),
            backgroundColor: Colors.white,
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
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Category.valueToCategory(_data.category).iconColor,
                )
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Category.valueToCategory(_data.category).icon,
                  color: Category.valueToCategory(_data.category).iconColor,
                  size: 24, 
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _data.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  if(_data.description != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      _data.description!,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    child: AutoSizeText(
                      "${_isIncome ? '+' : '-'}${_data.price.numToString()} ${_data.currency}",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: _isIncome ? AppColors().greenColor : AppColors().redColor,
                        fontWeight: FontWeight.bold
                      ),
                      maxLines: 1,
                      minFontSize: 12,
                      maxFontSize: 14,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      _data.transactionDate.dateToDateTime(),
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                      maxLines: 1,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}