import 'package:asset_flutter/content/widgets/settings/offers_sheet.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StatsLineChartPremiumView extends StatelessWidget {
  const StatsLineChartPremiumView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 36),
          child: Lottie.asset(
            "assets/lottie/premium.json",
            height: 100,
            width: 100
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(8, 16, 8, 16),
          child: Text(
            "Sorry, this function requires premium membership.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        TextButton(
          onPressed: () => showModalBottomSheet(
            context: context, 
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12)
              ),
            ),
            enableDrag: true,
            builder: (_) => const OffersSheet()
          ), 
          child: Text('See Membership Plans'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(50)
          )
        )
      ],
    );
  }
}