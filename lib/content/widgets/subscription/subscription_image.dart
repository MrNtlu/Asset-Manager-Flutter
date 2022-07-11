import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/images.dart';
import 'package:flutter/material.dart';

class SubscriptionImage extends StatelessWidget {
  final String _image;
  final Color _color;
  final double size;
  const SubscriptionImage(this._image, this._color, {
    this.size = 28,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.all(Radius.circular(size/2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size/2),
        child: SizedBox.fromSize(
          size: Size.fromRadius(size/2),
          child: Image.network(
            _image,
            width: size,
            height: size,
            fit: BoxFit.contain,
            frameBuilder: (context, child, int? frame, bool? wasSynchronouslyLoaded) {
              if (frame == null) {
                return CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors().primaryLightColor),
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
              return Icon(
                PlaceholderImages().subscriptionFailIcon(),
                size: size/2,
                color: _color,
              );
            }),
          )
        ),
      ),
    );
  }
}