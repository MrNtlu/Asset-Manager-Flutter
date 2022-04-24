import 'dart:io';

import 'package:asset_flutter/content/pages/subscription/card_create_page.dart';
import 'package:asset_flutter/content/providers/subscription/cards.dart';
import 'package:asset_flutter/content/widgets/subscription/cd_stats_sheet.dart';
import 'package:asset_flutter/content/widgets/subscription/cd_subscription_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardDetailsPage extends StatelessWidget {
  final String _creditCardID; 
  const CardDetailsPage(this._creditCardID, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _creditCard = Provider.of<CardProvider>(context).findById(_creditCardID);
  
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          _creditCard.name, 
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.white,
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
              builder: (_) => CardDetailsStatsSheet(_creditCardID)
            ), 
            icon: const Icon(Icons.bar_chart_rounded, size: 28)
          ),
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => CardCreatePage(false, creditCardID: _creditCardID))
            ), 
            icon: const Icon(Icons.edit_rounded, size: 28)
          )
        ],
      ),
      body: ChangeNotifierProvider.value(
        value: _creditCard,
        child: CardDetailsSubscriptionList(_creditCardID),
      ),
    );
  }
}