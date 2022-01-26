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
      height: _data.description != null ? 150 : 120,
      child: Card(
        elevation: 4,
        color: Color(_data.color),
        margin: const EdgeInsets.only(left: 8, bottom: 8, right: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubscriptionListCellImage(_data.image),
                SLText(_data.name, 1, 18, Alignment.center, const EdgeInsets.fromLTRB(12, 8, 12, 0))
              ],
            ),
            if(_data.description != null) 
            SLText(_data.description!, 2, 14, Alignment.centerLeft, 
              const EdgeInsets.all(12),
              textAlign: TextAlign.start,
              textColor: Colors.grey.shade200
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.bottomRight,
                margin: const EdgeInsets.only(right: 12, bottom: 12),
                child: Text(
                  _data.price.toString() + ' ' + _data.currency,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  )
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
          maxLines: 2,
          softWrap: true,
          overflow: TextOverflow.fade,
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