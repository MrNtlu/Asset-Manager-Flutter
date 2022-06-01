import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/providers/common/base_item_provider.dart';
import 'package:asset_flutter/static/routes.dart';

class DailyAssetStats {
  final String currency;
  final List<num> totalAssets;
  final List<num> totalPL;
  final List<DateTime> dates;

  const DailyAssetStats(this.currency, this.totalAssets, this.totalPL, this.dates);
}

class DailyStatsProvider extends BaseItemProvider<DailyAssetStats> {

  Future<BaseItemResponse<DailyAssetStats>> getDailyStats({required interval}) async 
    => getItem(url: APIRoutes().assetRoutes.dailyAssetStats + "?interval=$interval");
}