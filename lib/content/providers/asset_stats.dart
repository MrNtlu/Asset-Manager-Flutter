import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/models/responses/asset.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AssetStatsProvider with ChangeNotifier {
  AssetStats? assetStats;

  Future<BaseItemResponse<AssetStats>> getAssetStats() async {
    try {
      final response = await http.get(
        Uri.parse(APIRoutes().assetRoutes.assetStatsByUserID),
        headers: UserToken().getBearerToken()
      );

      assetStats = response.getBaseItemResponse<AssetStats>().data;
      notifyListeners();

      return response.getBaseItemResponse<AssetStats>();
    } catch (error) {
      return BaseItemResponse(message: error.toString());
    }
  }
}
