import 'package:asset_flutter/content/pages/portfolio_page.dart';
import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:flutter/material.dart';

class InvestmentListCellImage extends StatelessWidget {
  final imageBorderRadius = BorderRadius.circular(24);
  final String _image;
  final String _type;

  InvestmentListCellImage(this._image, this._type);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 8, 0, 8),
      padding: const EdgeInsets.all(0.2),
      decoration: BoxDecoration(
          color: const Color(0x40000000), borderRadius: imageBorderRadius),
      child: ClipRRect(
        borderRadius: imageBorderRadius,
        child: SizedBox.fromSize(
          size: const Size.fromRadius(24),
          child: Image.network(
            _image,
            width: 48,
            height: 48,
            fit: BoxFit.fill,
            frameBuilder: (BuildContext context, Widget child, int? frame,
                bool? wasSynchronouslyLoaded) {
              if (frame == null) {
                return const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(TabsPage.primaryLightColor),
                  backgroundColor: Colors.white,
                );
              }
              return child;
            },
            loadingBuilder: ((context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return const CircularProgressIndicator();
            }),
            errorBuilder: ((context, error, stackTrace) {
              if ((error as NetworkImageLoadException).statusCode == 404 &&
                  _type == "crypto") {
                return Image.network(TestData.cryptoFailImage());
              }
              return const Icon(Icons.error);
            }),
          ),
        ),
      ),
    );
  }
}