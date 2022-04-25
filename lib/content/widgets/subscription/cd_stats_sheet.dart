import 'dart:io';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/content/models/responses/card.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:http/http.dart' as http;
import 'package:asset_flutter/common/models/state.dart';
import 'package:flutter/material.dart';

class CardDetailsStatsSheet extends StatefulWidget {
  final String _cardID;
  const CardDetailsStatsSheet(this._cardID, {Key? key}) : super(key: key);

  @override
  State<CardDetailsStatsSheet> createState() => _CardDetailsStatsSheetState();
}

class _CardDetailsStatsSheetState extends State<CardDetailsStatsSheet> {
  DetailState _state = DetailState.init;
  CardStats? _cardStats;
  String? _error;

  void _getCardStats() {
    setState(() {
      _state = DetailState.loading;
    });

    try {
      http.get(
        Uri.parse(APIRoutes().cardRoutes.cardStatsByUserID + "?id=${widget._cardID}"),
        headers: UserToken().getBearerToken()
      ).then((response){
        if (_state != DetailState.disposed) {
          _cardStats = response.getBaseItemResponse<CardStats>().data;
          _error = _cardStats == null 
          ? (
            response.getBaseItemResponse<CardStats>().message.trim() == ''
            ? "Unknown error!"
            : response.getBaseItemResponse<CardStats>().message
          ) 
          : null;

          setState(() {
            _state = _cardStats == null ? DetailState.error : DetailState.view;
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
      _getCardStats();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
        child: _body(),
      ),
    );
  }

  Widget _body() {
    switch (_state) {
      case DetailState.loading:
        return const LoadingView("Fetching stats");
      case DetailState.error:
        return ErrorView(_error ?? "Unknown error!", _getCardStats);
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
                  "Monthly",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                ),
              ),
            ),
            DataColumn(
              numeric: true,
              label: FittedBox(
                child: Text(
                  "Total Paid",
                  style: TextStyle(
                    color: Colors.black,
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
                  Text(_cardStats!.currency, style: const TextStyle(fontWeight: FontWeight.bold))
                ),
                DataCell(
                  Text(_cardStats!.monthlyPayment.numToString() + ' ' + _cardStats!.currency)
                ),
                DataCell(
                  Text(_cardStats!.totalPayment.numToString() + ' ' + _cardStats!.currency)
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