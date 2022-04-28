import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:asset_flutter/static/routes.dart';

class DailyAssetStats {
  final String currency;
  final List<num> totalAssets;
  final List<num> totalPL;
  final List<DateTime> dates;

  const DailyAssetStats(this.currency, this.totalAssets, this.totalPL, this.dates);
}

class DailyStatsProvider with ChangeNotifier {
  DailyAssetStats? _item;

  DailyAssetStats? get item => _item;

  Future<BaseItemResponse<DailyAssetStats>> getDailyStats({
    required interval
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          APIRoutes().assetRoutes.dailyAssetStats + "?interval=$interval"
        ),
        headers: UserToken().getBearerToken()
      );

      var baseItemResponse = response.getBaseItemResponse<DailyAssetStats>();
      var data = baseItemResponse.data;

      if (data != null) {
        _item = data;

        notifyListeners();
      }

      return baseItemResponse;
    } catch (error) {
      return BaseItemResponse(message: error.toString());
    }
  }
}