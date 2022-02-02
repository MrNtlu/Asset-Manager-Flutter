import 'package:asset_flutter/content/pages/portfolio/portfolio_page.dart';
import 'package:asset_flutter/content/widgets/subscription/sl_cell_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SubscriptionListCell extends StatelessWidget {
  final TestSubscriptionData _data;

  const SubscriptionListCell(this._data);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105,
      child: Card(
        elevation: 4,
        color: Color(_data.color),
        margin: const EdgeInsets.only(left: 8, bottom: 12, right: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubscriptionListCellImage(_data.image),
                SLText(_data.name, 1, 18, Alignment.center, const EdgeInsets.fromLTRB(8, 8, 8, 0)),
              ],
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: Row(
                  children: [
                    if(_data.billCycle != null)
                    SLSubText(
                      _data.billCycle!.handleBillCycleString(), 
                      Alignment.bottomLeft
                    ),
                    SLSubText(
                      _data.price.toString() + ' ' + _data.currency, 
                      Alignment.bottomRight
                    )
                  ],
                ),
              ),
            ),
          ],
        )
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
    this._text, this._flex, this._textSize, 
    this._alignment, this._edgeInsets,
    {this.textColor = Colors.white, this.textAlign = TextAlign.center}
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: _flex,
      child: Container(
        alignment: _alignment,
        margin: _edgeInsets,
        child: AutoSizeText(
          _text,
          maxLines: 1,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
          minFontSize: _textSize,
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

  const SLSubText(this._text, this._alignment, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: _alignment,
        child: Text(
          _text,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.bold
          )
        ),
      )
    );
  }
}