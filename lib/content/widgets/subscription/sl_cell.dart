import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/check_dialog.dart';
import 'package:asset_flutter/content/providers/subscription/subscription.dart';
import 'package:asset_flutter/content/pages/subscription/subscription_details_page.dart';
import 'package:asset_flutter/content/providers/subscription/subscription_state.dart';
import 'package:asset_flutter/content/providers/subscription/subscriptions.dart';
import 'package:asset_flutter/content/widgets/subscription/sl_cell_image.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class SubscriptionListCell extends StatelessWidget {
  final Subscription subscription;
  final bool isCardDetails;

  const SubscriptionListCell(this.subscription, {this.isCardDetails = false});

  void _deleteSubscription(BuildContext context) {
    final _stateListener = Provider.of<SubscriptionStateProvider>(context, listen: false);
    final _refreshListener = Provider.of<SubscriptionRefreshProvider>(context, listen: false);

    _stateListener.setState(ListState.loading);
    Provider.of<SubscriptionsProvider>(context, listen: false).deleteSubscription(subscription.id).then((response){
      if (response.error == null) {
        _refreshListener.setRefresh(true);
      } else {
        _stateListener.setState(ListState.error, error: response.error);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => showDialog(
              context: context,
              builder: (ctx) => AreYouSureDialog('delete', (){
                Navigator.pop(ctx);
                _deleteSubscription(ctx);
              })
            ),
            backgroundColor: Theme.of(context).colorScheme.bgColor,
            foregroundColor: Colors.red,
            icon: Icons.delete_rounded,
            label: 'Delete',
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: ((context) => SubscriptionDetailsPage(subscription.id, isCardDetails: isCardDetails)))
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color(subscription.color),
            borderRadius: const BorderRadius.all(Radius.circular(6))
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              SubscriptionListCellImage(subscription.image),
              SLText(
                subscription.name, 
                5, 
                18, 
                Alignment.centerLeft,
                textAlign: TextAlign.left,
                const EdgeInsets.fromLTRB(12, 0, 4, 0)
              ),
              Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    SLSubText(
                      subscription.currency.getCurrencyFromString() + ' ' + subscription.price.toString(),
                      Alignment.centerRight,
                      18,
                      maxLines: 2,
                    ),
                    if(subscription.notificationTime != null)
                    const Positioned(
                      top: 2,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.only(left: 3),
                        child: Icon(Icons.notifications_active_rounded, size: 10, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 0,
                      child: SLSubText(
                        subscription.nextBillDate.dateToDaysLeft(),
                        Alignment.centerRight,
                        12,
                        textColor: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SLText extends StatelessWidget {
  final String _text;
  final int _flex;
  final double _textSize;
  final Alignment _alignment;
  final EdgeInsets _edgeInsets;
  final Color textColor;
  final TextAlign textAlign;

  const SLText(
      this._text, this._flex, this._textSize, this._alignment, this._edgeInsets,
      {this.textColor = Colors.white, this.textAlign = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: _flex,
      child: Container(
        alignment: _alignment,
        margin: _edgeInsets,
        child: AutoSizeText(
          _text,
          maxLines: 2,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
          minFontSize: _textSize - 4,
          style: TextStyle(
            fontSize: _textSize,
            color: textColor,
            fontWeight: FontWeight.bold
          )
        ),
      ),
    );
  }
}

class SLSubText extends StatelessWidget {
  final String _text;
  final Alignment _alignment;
  final double _fontSize;
  final Color textColor;
  final int maxLines;

  const SLSubText(this._text, this._alignment, this._fontSize, {this.textColor = Colors.white, this.maxLines = 1, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: _alignment,
      child: AutoSizeText(
        _text,
        minFontSize: _fontSize - 4,
        maxLines: maxLines,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: _fontSize, 
          color: textColor, 
          fontWeight: FontWeight.bold
        )
      ),
    );
  }
}
