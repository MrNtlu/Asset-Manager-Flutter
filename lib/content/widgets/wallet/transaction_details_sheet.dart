import 'package:asset_flutter/common/widgets/check_dialog.dart';
import 'package:asset_flutter/content/pages/wallet/transaction_create_page.dart';
import 'package:asset_flutter/content/providers/wallet/transaction.dart';
import 'package:asset_flutter/content/widgets/wallet/tds_text.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';

class TransactionDetailsSheet extends StatelessWidget {
  final Category _category;
  final Transaction _data;
  const TransactionDetailsSheet(this._data, this._category, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: _category.iconColor,
              )
            ),
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Icon(
                  _category.icon,
                  color: _category.iconColor,
                  size: 24, 
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    _category.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _category.iconColor
                    ),
                  ),
                )
              ],
            ),
          ),
          TransactionDetailsSheetText("Title", _data.title),
          if (_data.description != null)
          TransactionDetailsSheetText("Description", _data.description!),
          TransactionDetailsSheetText("Transaction Date", _data.transactionDate.dateToHumanDate()),
          if (_data.transactionMethod != null)
          TransactionDetailsSheetText("Transaction Method", _data.transactionMethod!.type == 0 ? "Bank Account" : "Credit Card"),
          TransactionDetailsSheetText(
            "Price",
            _data.currency.getCurrencyFromString() + _data.price.abs().numToString(), 
            textColor: _category != Category.income ? AppColors().redColor : AppColors().greenColor
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: Align(
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (ctx) => AreYouSureDialog("edit", (){
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => TransactionCreatePage(false, transactionID: _data.id))
                    );
                  }),
                ), 
                child: const Text("Edit")
              ),
            ),
          )
        ],
      ),
    );
  }
}