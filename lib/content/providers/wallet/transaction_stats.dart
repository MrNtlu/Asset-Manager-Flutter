import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/providers/common/base_item_provider.dart';
import 'package:asset_flutter/static/routes.dart';

class TransactionStats {
  final List<TransactionDailyStats> dailyStats;
  final TransactionCategoryStats categoryStats;
  final num totalExpense;
  final num totalIncome;

  const TransactionStats(this.dailyStats, this.categoryStats, this.totalExpense, this.totalIncome);
}

class TransactionDailyStats {
  final String currency;
  final num totalTransaction;
  final DateTime date;

  const TransactionDailyStats(this.currency, this.totalTransaction, this.date);
}

class TransactionCategoryStats {
  final String currency;
  final num totalTransaction;
  final List<TransactionCategoryStat> categoryList;

  const TransactionCategoryStats(this.currency, this.totalTransaction, this.categoryList);
}

class TransactionCategoryStat {
  final int categoryID;
  final num totalCategoryTransaction;

  const TransactionCategoryStat(this.categoryID, this.totalCategoryTransaction);
}

class TransactionStatsProvider extends BaseItemProvider<TransactionStats>{

  Future<BaseItemResponse<TransactionStats>> getTransactionStats({required String interval}) async
    => getItem(url: APIRoutes().transactionRoutes.transactionStats+"?interval=$interval");
}
