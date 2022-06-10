import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/content/models/responses/bank_account.dart';
import 'package:asset_flutter/content/providers/wallet/bank_account.dart';
import 'package:asset_flutter/content/providers/wallet/bank_accounts.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class BankAccountDetailsSheet extends StatefulWidget {
  final String _bankAccID;

  const BankAccountDetailsSheet(this._bankAccID, {Key? key}) : super(key: key);

  @override
  State<BankAccountDetailsSheet> createState() => _BankAccountDetailsSheetState();
}

class _BankAccountDetailsSheetState extends State<BankAccountDetailsSheet> {
  DetailState _state = DetailState.init;
  late final BankAccountProvider _bankAccProvider;
  BankAccountStats? _bankAccStats;
  String? _error;

  void _getBankAccStats() {
    setState(() {
      _state = DetailState.loading;
    });

    try {
      http.get(
        Uri.parse(APIRoutes().bankAccRoutes.bankAccStatsByUserID + "?method_id=${widget._bankAccID}&type=0"),
        headers: UserToken().getBearerToken()
      ).then((response){
        if (_state != DetailState.disposed) {
          _bankAccStats = response.getBaseItemResponse<BankAccountStats>().data;
          _error = _bankAccStats == null 
          ? response.getBaseItemResponse<BankAccountStats>().error ?? "Unknown error!"
          : null;

          setState(() {
            _state = _bankAccStats == null ? DetailState.error : DetailState.view;
          }); 
        }
      }).onError((error, stackTrace) {
        _error = error.toString();
        setState(() {
          _state = DetailState.error;
        });
      });
    } catch(error) {
      _error = error.toString();
      setState(() {
        _state = DetailState.error;
      });
    }
  }

  @override
  void dispose() {
    _state = DetailState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == DetailState.init) {
      _bankAccProvider = Provider.of<BankAccountProvider>(context);

      _getBankAccStats();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    late final BankAccount _bankAcc;
    try {
      _bankAcc = _bankAccProvider.findById(widget._bankAccID);
    } catch (_) {
      _bankAcc = BankAccount('', '', '', '', '');
    }

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(bottom: 16),
        decoration: Platform.isIOS || Platform.isMacOS
        ? const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16)
          ),
        )
        : null,
        child: _body(_bankAcc),
      ),
    );
  }

  Widget _body(BankAccount _bankAcc) {
    switch (_state) {
      case DetailState.loading:
        return const LoadingView("Getting stats");
      case DetailState.error:
        return ErrorView(_error ?? "Unknown error!", _getBankAccStats);
      case DetailState.view:
        return DataTable(
          columns: const [
            DataColumn(
              numeric: false,
              label: FittedBox(
                child: null,
              ),
            ),
            DataColumn(
              numeric: true,
              label: FittedBox(
                child: Text(
                  "Total Transactions",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
              ),
            ),
          ],
          rows: [
            DataRow(
              cells: [
                DataCell(
                  Text(_bankAccStats!.currency, style: const TextStyle(fontWeight: FontWeight.bold))
                ),
                DataCell(
                  Text(
                    _bankAccStats!.currency.getCurrencyFromString() + _bankAccStats!.totalTransaction.abs().numToString(),
                    style: TextStyle(
                      color: _bankAccStats!.totalTransaction > 0 ? AppColors().redColor : AppColors().greenColor,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ),
              ]
            )
          ],
        );
      default:
        return const LoadingView("Loading");
    }
  }
}