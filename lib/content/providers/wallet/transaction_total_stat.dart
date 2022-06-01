import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/providers/common/base_item_provider.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/utils/extensions.dart';

class TransactionTotalStats {
  final String currency;
  final num totalTransaction;

  const TransactionTotalStats(this.currency, this.totalTransaction);
}

class TransactionTotalStatsProvider extends BaseItemProvider<TransactionTotalStats> {
  
  Future<BaseItemResponse<TransactionTotalStats>> getDailyStats({required interval}) async 
    => getItem(url: APIRoutes().transactionRoutes.totalTransactionByInterval 
      + "?interval=$interval&transaction_date=${DateTime.now().dateToSimpleJSONFormat()}");
}
