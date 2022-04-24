import 'package:asset_flutter/content/models/responses/asset.dart';
import 'package:asset_flutter/content/models/responses/card.dart';
import 'package:asset_flutter/content/models/responses/investings.dart';
import 'package:asset_flutter/content/models/responses/subscription.dart';
import 'package:asset_flutter/content/models/responses/user.dart';
import 'package:asset_flutter/content/providers/asset.dart';
import 'package:asset_flutter/content/providers/market/prices.dart';
import 'package:asset_flutter/content/providers/portfolio/daily_stats.dart';
import 'package:asset_flutter/content/providers/subscription/card.dart';
import 'package:asset_flutter/content/providers/subscription/subscription.dart';

class BaseAPIResponse {
  final String? error;

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
      var _typeConverter = _TypeConverter<T>();
      data = _typeConverter.convertToObject(response);
    } else {
      data = null;
    }
  }
}

class BasePaginationResponse<T> {
  late List<T> data = [];
  late bool canNextPage;
  final String? error;

  BasePaginationResponse({
    List<dynamic>? response,
    required this.canNextPage,
    this.error
  }){
    if (response != null) {
      var _typeConverter = _TypeConverter<T>();
      response.map((e){
        return e as Map<String, dynamic>;
      }).forEach((element) {
        data.add(_typeConverter.convertToObject(element));
      });
    }
  }
}

class BaseListResponse<T> {
  late List<T> data = [];
  final String? message;
  final int? code;
  final String? error;

  BaseListResponse({
    List<dynamic>? response,
    this.message,
    this.code,
    this.error
  }){
    if (response != null) {
      var _typeConverter = _TypeConverter<T>();
      response.map((e) {
        return e as Map<String, dynamic>; 
      }).forEach((element) { 
        data.add(_typeConverter.convertToObject(element));
      });
    }
  }
}

class AssetResponse {
  late AssetStats? stats;
  late List<Asset> data = [];
  final String? message;
  final int? code;
  final String? error;

  AssetResponse({
    List<dynamic>? response,
    this.message,
    this.code,
    this.error,
    Map<String, dynamic>? statsResponse
  }) {
    if (response != null) {
      var _typeConverter = _TypeConverter<Asset>();
      response.map((e) {
        return e as Map<String, dynamic>; 
      }).forEach((element) { 
        data.add(_typeConverter.convertToObject(element));
      });
    }

    if (statsResponse != null) {
      var _typeConverter = _TypeConverter<AssetStats>();
      stats = _typeConverter.convertToObject(statsResponse);
    } else {
      stats = null;
    }
  }
}

class SubscriptionResponse {
  late List<SubscriptionStats> stats = [];
  late List<Subscription> data = [];
  final String? message;
  final int? code;
  final String? error;

  SubscriptionResponse({
    List<dynamic>? response,
    this.message,
    this.code,
    this.error,
    List<dynamic>? statsResponse
  }) {
    if (response != null) {
      var _typeConverter = _TypeConverter<Subscription>();
      response.map((e) {
        return e as Map<String, dynamic>; 
      }).forEach((element) { 
        data.add(_typeConverter.convertToObject(element));
      });
    }

    if (statsResponse != null) {
      var _typeConverter = _TypeConverter<SubscriptionStats>();
      statsResponse.map((e) {
        return e as Map<String, dynamic>; 
      }).forEach((element) { 
        stats.add(_typeConverter.convertToObject(element));
      });
    }
  }
}

class _TypeConverter<T> {
  T convertToObject(Map<String, dynamic> response){
    if (T == Asset) {
      return Asset(
        response["current_total_value"],
        response["name"],
        response["to_asset"],
        response["from_asset"],
        response["asset_type"],
        response["asset_market"],
        response["p/l"],
        response["remaining_amount"],
      ) as T;
    } else if (T == AssetLog) {
      return AssetLog(
        response["_id"],
        response["value"],
        response["to_asset"],
        response["from_asset"],
        response["type"],
        response["amount"], 
        DateTime.parse(response["created_at"]),
        response["price"],
        response["asset_market"],
      ) as T;
    } else if (T == AssetStats) {
      return AssetStats(
        response["currency"],
        response["total_bought"],
        response["total_sold"],
        response["stock_assets"],
        response["crypto_assets"],
        response["exchange_assets"],
        response["commodity_assets"],
        response["total_assets"],
        response["stock_p/l"],
        response["crypto_p/l"],
        response["exchange_p/l"],
        response["commodity_p/l"],
        response["total_p/l"],
        response["stock_percentage"],
        response["crypto_percentage"],
        response["exchange_percentage"],
        response["commodity_percentage"],
      ) as T;
    } else if (T == Investings) {
      return Investings(
        response["name"],
        response["symbol"]
      ) as T;
    } else if (T == Subscription) {
      return Subscription(
        response["_id"], 
        response["name"],
        response["description"],
        DateTime.parse(response["bill_date"]),
        BillCycle(
          day: response["bill_cycle"]["day"],
          month: response["bill_cycle"]["month"],
          year: response["bill_cycle"]["year"]
        ),
        response["price"],
        response["currency"],
        response["image"],
        response["color"],
        response["card_id"]
      ) as T;
    } else if (T == SubscriptionDetails) {
      return SubscriptionDetails(
        response["monthly_payment"], 
        response["total_payment"]
      ) as T;
    } else if (T == BillCycle) {
      return BillCycle(
        day: response["day"],
        month: response["month"],
        year: response["year"]
      ) as T;
    } else if (T == SubscriptionStats) {
      return SubscriptionStats(
        response["currency"], 
        response["total_monthly_payment"],
        response["total_payment"]
      ) as T;
    } else if (T == MarketPrices) {
      return MarketPrices(
        response["name"], 
        response["symbol"], 
        response["currency"], 
        response["market"], 
        response["price"]) as T;
    } else if (T == DailyAssetStats) {
      return DailyAssetStats(
        response["currency"],
        response["total_assets"] != null ? ((response["total_assets"]) as List).map((e) => e as num).toList() : [],
        response["total_p/l"] != null ? ((response["total_p/l"]) as List).map((e) => e as num).toList() : [],
      ) as T;
    } else if (T == UserInfo) {
      return UserInfo(
        response["is_premium"],
        response["email_address"],
        response["currency"],
        response["investing_limit"],
        response["subscription_limit"],
      ) as T;
    } else if (T == Investings) {
      return Investings(
        response["name"],
        response["symbol"],
      ) as T;
    } else if (T == CreditCard) {
      return CreditCard(
        response["_id"],
        response["name"],
        response["last_digit"],
        response["card_holder"],
        response["color"],
        response["type"],
      ) as T;
    } else if (T == CardStats) {
      return CardStats(
        response["currency"],
        response["total_monthly_payment"],
        response["total_payment"],
        response["most_expensive_name"],
        response["most_expensive"]
      ) as T;
    } else{
      return response as T;
    }
  }
}