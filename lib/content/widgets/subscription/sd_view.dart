import 'dart:io';

import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/check_dialog.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/success_view.dart';
import 'package:asset_flutter/content/models/responses/subscription.dart';
import 'package:asset_flutter/content/providers/subscription/subscription.dart';
import 'package:asset_flutter/content/providers/subscription/subscription_details.dart';
import 'package:asset_flutter/content/providers/subscription/subscription_state.dart';
import 'package:asset_flutter/content/providers/subscription/subscriptions.dart';
import 'package:asset_flutter/content/widgets/subscription/sd_view_text.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_card/awesome_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SubscriptionDetailsView extends StatefulWidget {
  final Subscription _data;
  final bool isCardDetails;

  bool canEnterEditMode = true;

  SubscriptionDetailsView(this._data, {
    this.isCardDetails = false,
    Key? key
  }) : super(key: key);

  @override
  State<SubscriptionDetailsView> createState() => _SubscriptionDetailsViewState();
}

class _SubscriptionDetailsViewState extends State<SubscriptionDetailsView> {
  DetailState _state = DetailState.view;
  SubscriptionDetails? _subscriptionDetails;
  final bool isApple = Platform.isIOS || Platform.isMacOS;

  void _deleteSubscription() {
    widget.canEnterEditMode = false;

    setState(() {
      _state = DetailState.loading;
    });
    Provider.of<SubscriptionsProvider>(context, listen: false).deleteSubscription(widget._data.id).then((response){
      if (_state != DetailState.disposed) {
        if (response.error == null) {
          Provider.of<SubscriptionRefreshProvider>(context, listen: false).setRefresh(true);
          setState(() {
            _state = DetailState.view;
          });
          showDialog(
            barrierDismissible: false,
            barrierColor: Colors.black54,
            context: context,
            builder: (ctx) => const SuccessView("deleted", isNonTabView: true)
          );
        } else {
          setState(() {
            _state = DetailState.view;
          });
          showDialog(
            context: context, 
            builder: (ctx) => ErrorDialog(response.error.toString())
          );
        }

        widget.canEnterEditMode = true;
      }
    });
  }

  void _getSubscriptionDetails() {
    setState(() {
      _state = DetailState.loading;
    });

    Provider.of<SubscriptionDetailsProvider>(context, listen: false).getSubscriptionDetails(widget._data.id).then((response){
      if (_state != DetailState.disposed) {
        _subscriptionDetails = response.data;
        setState(() {
          _state = DetailState.view;
        });
      }
    });
  }

  @override
  void dispose() {
    _state = DetailState.disposed;
    widget.canEnterEditMode = true;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _getSubscriptionDetails();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    switch (_state) {
      case DetailState.view:
        return Column(
          children: [
            Container(
              height: 110,
              width: double.infinity,
              color: Color(widget._data.color),
              margin: const EdgeInsets.only(bottom: 8),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                      alignment: Alignment.bottomCenter,
                      child: AutoSizeText(
                        widget._data.currency.getCurrencyFromString() + ' ' +widget._data.price.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26
                        ),
                      ),
                    )
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 6),
                      alignment: Alignment.topCenter,
                      child: Text(
                        widget._data.nextBillDate.dateToDaysLeft(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                        ),
                      ),
                    )
                  )
                ],
              ),
            ),
            if (widget._data.description != null)
            SDViewText("Description", widget._data.description!),
            if (_subscriptionDetails != null && _subscriptionDetails?.card != null)
            Stack(
              children: [
                SDViewText("Credit Card", _subscriptionDetails!.card!.name + ' ' + _subscriptionDetails!.card!.lastDigits),
                Positioned(
                  bottom: 0,
                  top: 0,
                  right: 4,
                  child: getCardTypeIcon(cardType: _cardTypeMapper(_subscriptionDetails!.card!.type))
                )
              ],
            ),
            SDViewText("Initial Bill Date", widget._data.billDate.dateToFormatDate()),
            SDViewText("Next Bill Date", widget._data.nextBillDate.dateToFormatDate()),
            if(widget._data.notificationTime != null)
            Stack(
              children: [
                SDViewText("Reminder Time", widget._data.notificationTime!.toLocal().dateToTime()),
                const Positioned(
                  bottom: 0,
                  top: 0,
                  right: 4,
                  child: Icon(Icons.notifications_on_rounded)
                )
              ],
            ),
            SDViewText("Bill Cycle", widget._data.billCycle.handleBillCycleString()),
            if(_subscriptionDetails != null)
            SDViewText(
              "Monthly Payment",
              widget._data.currency.getCurrencyFromString() + ' ' + _subscriptionDetails!.monthlyPayment.numToString()
            ),
            if(_subscriptionDetails != null)
            SDViewText(
              "Paid in Total",
              widget._data.currency.getCurrencyFromString() + ' ' + _subscriptionDetails!.totalpayment.numToString()
            ),
            if(widget._data.account != null)
            ListTileTheme(
              contentPadding: EdgeInsets.zero,
              dense: true,
              horizontalTitleGap: 0.0,
              minLeadingWidth: 0,
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  children: [
                    _accountText("Username/Email ", widget._data.account!.email),
                    if(widget._data.account!.password != null && widget._data.account!.password!.isNotEmpty)
                    _accountText("Password ", widget._data.account!.password),
                  ],
                  textColor: Theme.of(context).colorScheme.bgTextColor,
                  iconColor: Theme.of(context).colorScheme.bgTextColor,
                  collapsedTextColor: Theme.of(context).colorScheme.bgTextColor,
                  collapsedIconColor: Theme.of(context).colorScheme.bgTextColor,
                  tilePadding: const EdgeInsets.symmetric(horizontal: 6),
                  childrenPadding: const EdgeInsets.symmetric(horizontal: 6),
                  initiallyExpanded: false,
                  title: const Text(
                    "Account",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ),
              ),
            ),
            if(!widget.isCardDetails)
            Padding(
              padding: const EdgeInsets.all(12),
              child: isApple
              ? CupertinoButton(
                onPressed: () {
                  showCupertinoDialog(
                    context: context, 
                    builder: (ctx) => AreYouSureDialog('delete', (){
                      Navigator.pop(context);
                      _deleteSubscription();
                    })
                  );
                },
                child: const Text("Delete Subscription")
              )
              : TextButton(
                onPressed: () {
                  showDialog(
                    context: context, 
                    builder: (ctx) => AreYouSureDialog('delete', (){
                      Navigator.pop(context);
                      _deleteSubscription();
                    })
                  );
                },
                child: const Text("Delete Subscription")
              ),
            )
          ],
        );
      case DetailState.loading:
      default:
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: const LoadingView("Loading")
        );
    }
  }

  CardType _cardTypeMapper(String cardType) {
    switch (cardType) {
      case "AmericanExpress":
        return CardType.americanExpress;
      case "MasterCard":
        return CardType.masterCard;
      case "Visa":
        return CardType.visa;
      case "Maestro":
        return CardType.maestro;
      default:
        return CardType.masterCard;
    }
  }

  Widget _accountText(title, info) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 17,
                color: Theme.of(context).colorScheme.bgTransparentColor
              ),
            ),
          ),
          Text(
            info,
            style: TextStyle(
              fontSize: 17,
              color: Theme.of(context).colorScheme.bgTextColor
            ),
          ),
        ],
      ),
    ),
  );
}