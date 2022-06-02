import 'package:asset_flutter/content/providers/subscription/subscription.dart';
import 'package:asset_flutter/content/pages/subscription/subscription_details_page.dart';
import 'package:asset_flutter/content/widgets/subscription/sl_cell_image.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SubscriptionListCell extends StatelessWidget {
  final Subscription subscription;
  final bool isCardDetails;

  const SubscriptionListCell(this.subscription, {this.isCardDetails = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                    subscription.price.toString() + ' ' + subscription.currency,
                    Alignment.centerRight,
                    16,
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

  const SLSubText(this._text, this._alignment, this._fontSize, {this.textColor = Colors.white, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: _alignment,
      child: AutoSizeText(
        _text,
        minFontSize: _fontSize - 4,
        maxLines: 1,
        style: TextStyle(
          fontSize: _fontSize, 
          color: textColor, 
          fontWeight: FontWeight.bold
        )
      ),
    );
  }
}
