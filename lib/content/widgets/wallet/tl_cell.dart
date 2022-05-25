import 'package:asset_flutter/content/providers/wallet/transaction.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TransactionListCell extends StatelessWidget {
  final Transaction _data;
  const TransactionListCell(this._data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _isIncome = _data.category == Category.income.value;

    return ListTile(
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
    );
  }
}