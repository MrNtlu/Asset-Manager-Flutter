import 'dart:io';

import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/check_dialog.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/content/pages/subscription/card_create_page.dart';
import 'package:asset_flutter/content/providers/subscription/card.dart';
import 'package:asset_flutter/content/providers/subscription/cards.dart';
import 'package:asset_flutter/content/widgets/subscription/cd_stats_sheet.dart';
import 'package:asset_flutter/content/widgets/subscription/cd_subscription_list.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardDetailsPage extends StatefulWidget {
  final String _creditCardID; 
  const CardDetailsPage(this._creditCardID, {Key? key}) : super(key: key);

  @override
  State<CardDetailsPage> createState() => _CardDetailsPageState();
}

class _CardDetailsPageState extends State<CardDetailsPage> {
  ViewState _state = ViewState.init;
  late final CardProvider _cardProvider;

  Widget _deleteDialog(BuildContext context, String id) => AreYouSureDialog("delete credit card", () {
    Navigator.pop(context);
    setState(() {
      _state = ViewState.empty;
    });

    _cardProvider.deleteCreditCard(id).then((response) {
      if (_state != ViewState.disposed) {
        if (response.error != null) {
          setState(() {
            _state = ViewState.done;
          });
          showDialog(
            context: context, 
            builder: (ctx) => ErrorDialog(response.error!)
          );
        } else {
          Navigator.pop(context);
        } 
      }
    });
  });

  void _deleteCreditCard(BuildContext context, String id) {
    Platform.isMacOS || Platform.isIOS
    ? showCupertinoDialog(
      context: context, 
      builder: (_) => _deleteDialog(context, id)
    )
    : showDialog(
      context: context, 
      builder: (_) => _deleteDialog(context, id)
    );
  }

  @override
  void dispose() {
    _state = ViewState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ViewState.init) {
      _cardProvider = Provider.of<CardProvider>(context);

      _state = ViewState.done;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _creditCard = _cardProvider.findById(widget._creditCardID);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(int.parse(_creditCard.color)).getThemeColor(),
        ),
        title: Text(
          _creditCard.name, 
          style: TextStyle(color: _getThemeColor(_creditCard.color), fontWeight: FontWeight.bold)
        ),
        backgroundColor: Color(int.parse(_creditCard.color)),
        actions: [
          IconButton(
            onPressed: () => showModalBottomSheet(
              context: context,
              shape: Platform.isIOS || Platform.isMacOS
              ? const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16),
                  topLeft: Radius.circular(16)
                ),
              )
              : null,
              enableDrag: true,
              isDismissible: true,
              builder: (_) => CardDetailsStatsSheet(widget._creditCardID)
            ), 
            icon: const Icon(Icons.bar_chart_rounded, size: 28)
          ),
          IconButton(
            onPressed: () => _deleteCreditCard(context, _creditCard.id), 
            icon: const Icon(Icons.delete_rounded, size: 28)
          ),
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => CardCreatePage(false, creditCardID: widget._creditCardID))
            ), 
            icon: const Icon(Icons.edit_rounded, size: 28)
          )
        ],
      ),
      body: _body(_creditCard),
    );
  }

  Widget _body(CreditCard _creditCard) {
    switch (_state) {
      case ViewState.done:
        return ChangeNotifierProvider.value(
          value: _creditCard,
          child: CardDetailsSubscriptionList(widget._creditCardID),
        );
      default:
        return const LoadingView("Loading");
    }
  }

  Color _getThemeColor(String color) => ThemeData.estimateBrightnessForColor(Color(int.parse(color))) == Brightness.light ? Colors.black : Colors.white;
}