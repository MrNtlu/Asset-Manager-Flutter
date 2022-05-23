import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/providers/common/base_pagination_provider.dart';
import 'package:asset_flutter/content/providers/common/base_provider.dart';
import 'package:asset_flutter/static/routes.dart';

class TransactionCalendarCount {
  final DateTime time;
  final int count;

  const TransactionCalendarCount(this.time, this.count);
}

class TransactionCalendarCountsProvider extends BaseProvider<TransactionCalendarCount> {
  
  Future<BaseListResponse<TransactionCalendarCount>> getTransactionCalendarCounts(DateTime date) async 
    => getList(url: APIRoutes().transactionRoutes.calendarTransactionCount + "?month=${date.month}&year=${date.year}");
}
