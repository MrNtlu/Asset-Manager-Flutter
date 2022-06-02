import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/images.dart';
import 'package:flutter/material.dart';

class SubscriptionListCellImage extends StatelessWidget {
  final String? _image;

  const SubscriptionListCellImage(this._image);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6))
      ),
      padding: const EdgeInsets.all(2),
      child: SizedBox.fromSize(
        size: const Size.square(48),
        child: SLNetworkImage(_image)
      ),
    );
  }
}

class SLNetworkImage extends StatelessWidget {
  final String? _image;
  final bool didFailBefore;

  const SLNetworkImage(this._image, {this.didFailBefore = false});

  @override
  Widget build(BuildContext context) {
    return _image != null ? 
    Image.network(
      _image!,
      width: 48,
      height: 48,
      fit: BoxFit.contain,
      frameBuilder: (context, child, int? frame, bool? wasSynchronouslyLoaded) {
        if (frame == null) {
          return CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors().primaryLightColor),
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
        if(!didFailBefore){
          return SLNetworkImage(_image, didFailBefore: true);  
        }
        return Icon(
          PlaceholderImages().subscriptionFailIcon(),
          size: 36,
        );
      }),
    )
    : 
    Icon(
      PlaceholderImages().subscriptionFailIcon(),
      size: 36,
    );
  }
}