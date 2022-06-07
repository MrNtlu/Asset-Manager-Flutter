import 'package:asset_flutter/content/models/responses/asset.dart';
import 'package:asset_flutter/content/models/responses/bank_account.dart';
import 'package:asset_flutter/content/models/responses/card.dart';
import 'package:asset_flutter/content/models/responses/investings.dart';
import 'package:asset_flutter/content/models/responses/subscription.dart';
import 'package:asset_flutter/content/models/responses/transaction.dart';
import 'package:asset_flutter/content/models/responses/user.dart';
import 'package:asset_flutter/content/providers/asset.dart';
import 'package:asset_flutter/content/providers/market/prices.dart';
import 'package:asset_flutter/content/providers/portfolio/daily_stats.dart';
import 'package:asset_flutter/content/providers/subscription/card.dart';
import 'package:asset_flutter/content/providers/subscription/subscription.dart';
import 'package:asset_flutter/content/providers/wallet/bank_account.dart';
import 'package:asset_flutter/content/providers/wallet/transaction.dart';
import 'package:asset_flutter/content/providers/wallet/transaction_calendar.dart';
import 'package:asset_flutter/content/providers/wallet/transaction_stats.dart';
import 'package:asset_flutter/content/providers/wallet/transaction_total_stat.dart';

class BaseAPIResponse {
  final String? error;

  const BaseAPIResponse(this.error);
}

class BaseItemResponse<T> {
  late T? data;
  final String message;
  final String? error;

  BaseItemResponse({
    Map<String, dynamic>? response,
    required this.message,
    this.error
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
        response["pl_percentage"],
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
        response["total_pl_percentage"],
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
        DateTime.parse(response["next_bill_date"]),
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
    } else if (T == Transaction) {
      return Transaction(
        response["_id"], 
        response["title"],
        response["description"],
        response["category"],
        response["price"],
        response["currency"],
        DateTime.parse(response["transaction_date"]),
        response["method"] != null
        ? TransactionMethod(
          methodID: response["method"]["method_id"],
          type: response["method"]["type"],
        )
        : null,
      ) as T;
    } else if (T == TransactionCalendarCount) {
      return TransactionCalendarCount(
        DateTime.parse(response["_id"]), 
        response["count"]
      ) as T;
    }  else if (T == SubscriptionDetails) {
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
        response["dates"] != null ? ((response["dates"]) as List).map((e) => DateTime.parse(e)).toList() : [],
      ) as T;
    } else if (T == TransactionTotalStats) {
      return TransactionTotalStats(
        response["currency"],
        response["total_transaction"],
      ) as T;
    } else if (T == UserInfo) {
      return UserInfo(
        response["is_premium"],
        response["is_lifetime_premium"],
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
        response["currency"]
      ) as T;
    } else if (T == BankAccount) {
      return BankAccount(
        response["_id"],
        response["name"],
        response["iban"],
        response["account_holder"],
        response["currency"]
      ) as T;
    } else if (T == BankAccountStats) {
      return BankAccountStats(
        response["currency"],
        response["total_transaction"],
      ) as T;
    } else if (T == CardStats) {
      return CardStats(
        CardSubscriptionStats(
          response["subscription_stats"]["currency"],
          response["subscription_stats"]["total_monthly_payment"],
          response["subscription_stats"]["total_payment"]
        ),
        CardTransactionTotal(
          response["transaction_stats"]["currency"],
          response["transaction_stats"]["total_transaction"]
        )
      ) as T;
    } else if (T == TransactionStats) {
      return TransactionStats(
        response["daily_stats"] != null 
          ? ((response["daily_stats"]) as List
          ).map((e) => TransactionDailyStats(
            e["currency"],
            e["total_transaction"],
            DateTime.parse(e["date"]),
          )).toList() : [],
        TransactionCategoryStats(
          response["category_stats"]["currency"],
          response["category_stats"]["total_transaction"],
          response["category_stats"]["category_list"] != null 
            ? ((response["category_stats"]["category_list"]) as List
            ).map((e) => TransactionCategoryStat(
              e["_id"],
              e["total_transaction"],
            )).toList() : [],
        ),
        response["total_expense"],
        response["total_income"],
      ) as T;
    } else{
      return response as T;
    }
  }
}