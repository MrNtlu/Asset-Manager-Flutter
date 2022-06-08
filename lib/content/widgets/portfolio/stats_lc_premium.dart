import 'package:asset_flutter/content/widgets/settings/offers_sheet.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StatsLineChartPremiumView extends StatelessWidget {
  final double _topPadding;
  final Color textColor;
  const StatsLineChartPremiumView(this._topPadding, {this.textColor = Colors.white, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 36),
          child: Lottie.asset(
            "assets/lottie/premium.json",
            height: 100,
            width: 100,
            frameRate: FrameRate(60)
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(8, 16, 8, 16),
          child: Text(
            "Sorry, this function requires premium membership.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
            ),
          ),
        ),
        TextButton(
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            enableDrag: false,
            backgroundColor: AppColors().bgSecondary,
            builder: (_) => Padding(
              padding: EdgeInsets.only(top: _topPadding),
              child: const OffersSheet()
            )
          ), 
          child: const Text('See Membership Plans'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50)
          )
        )
      ],
    );
  }
}