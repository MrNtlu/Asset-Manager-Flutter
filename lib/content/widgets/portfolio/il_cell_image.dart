import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/images.dart';
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
          child: ILNetworkImage(_image, _type)
        ),
      ),
    );
  }
}

class ILNetworkImage extends StatelessWidget {
  final String _image;
  final bool didFailBefore;
  final String _type;

  const ILNetworkImage(this._image, this._type, {this.didFailBefore = false});

  @override
  Widget build(BuildContext context) {
    return _imageBodyByType(_type);
  }

  Widget _imageBodyByType(String _type) {
    if (_type == "stock" || _type == "commodity") {
      return Image.asset(
        _image, 
        package: _type == "stock" ? 'country_icons': null,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        frameBuilder: (context, child, int? frame, bool? wasSynchronouslyLoaded) {
          if (frame == null) {
            return CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors().primaryLightColor),
              backgroundColor: Colors.white,
            );
          }
          return child;
        },
        errorBuilder: ((context, error, stackTrace) {
          if(!didFailBefore){
            switch (_type) {
              case "crypto":
                return ILNetworkImage(PlaceholderImages().cryptoFailImage(), _type, didFailBefore: true);
              case "stock":
                return Icon(PlaceholderImages().stockFailIcon());
              case "exchange":
                return Icon(PlaceholderImages().exchangeFailIcon());
            }
          }
          return const Icon(Icons.error);
        }
      ));
    }
    return Image.network(
      _image,
      width: 48,
      height: 48,
      fit: BoxFit.cover,
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
          switch (_type) {
            case "crypto":
              return ILNetworkImage(PlaceholderImages().cryptoFailImage(), _type, didFailBefore: true);
            case "stock":
              return Icon(PlaceholderImages().stockFailIcon());
            case "exchange":
              return Icon(PlaceholderImages().exchangeFailIcon());
          }
        }
        return const Icon(Icons.error);
      }
    ));
  }
}