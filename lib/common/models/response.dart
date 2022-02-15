import 'package:asset_flutter/content/models/responses/asset.dart';

class BaseAPIResponse {
  final String? error;
  //final String? message;

  const BaseAPIResponse(this.error);
}

class BaseItemResponse<T> {
  late T? data;
  final String message;

  BaseItemResponse({
    Map<String, dynamic>? response,
    required this.message
  }){
    if (response != null) {
      if (T == AssetStats) {
        data = AssetStats(
          response["currency"],
          response["total_bought"],
          response["total_sold"],
          response["stock_assets"],
          response["crypto_assets"],
          response["exchange_assets"],
          response["total_assets"],
          response["stock_p/l"],
          response["crypto_p/l"],
          response["exchange_p/l"],
          response["total_p/l"],
          response["stock_percentage"],
          response["crypto_percentage"],
          response["exchange_percentage"],
        ) as T;
      }else{
        
      }
    }
  }
}
