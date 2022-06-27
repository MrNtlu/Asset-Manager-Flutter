import 'dart:convert';
import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/models/requests/asset.dart';
import 'package:asset_flutter/content/models/responses/asset.dart';
import 'package:asset_flutter/content/providers/common/base_pagination_provider.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:http/http.dart' as http;

class AssetLogProvider extends BasePaginationProvider<AssetLog> {

  Future<BasePaginationResponse<AssetLog>> getAssetLogs({
    required String toAsset,
    required String fromAsset,
    int page = 1,
    String sort = "newest", // newest oldest amount
    required String assetMarket,
  }) async {
    if (page == 1) {
      pitems.clear();
    }

    return getList(
      url: APIRoutes().assetRoutes.assetLogsByUserID 
        + "?to_asset=$toAsset&from_asset=$fromAsset&sort=$sort&page=$page&asset_market=$assetMarket"
    );
  }

  Future<BaseAPIResponse> createAsset(AssetCreate assetCreate) async
    => createItem<AssetCreate>(assetCreate, url: APIRoutes().assetRoutes.createAsset);

  Future<BaseAPIResponse> addAssetLog(AssetCreate assetCreate) async
    => createItem<AssetCreate>(assetCreate, url: APIRoutes().assetRoutes.createAssetLog);

  Future<BaseAPIResponse> deleteAssetLog(String id, AssetLog _item) async
    => deleteItem(id, url: APIRoutes().assetRoutes.deleteAssetLogByLogID, deleteItem: _item);

  Future<BaseAPIResponse> editAssetLog(AssetLog assetLog, bool isAmountChanged) async {
    try {
      final response = await http.put(
        Uri.parse(APIRoutes().assetRoutes.updateAssetLogByAssetID),
        body: json.encode(
          AssetUpdate(
            assetLog.id, 
            amount: isAmountChanged ? assetLog.amount.toDouble() : null,
            price: assetLog.price.toDouble(),
            type: assetLog.type
          ).convertToJson()
        ),
        headers: UserToken().getBearerToken()
      );

      if (response.getBaseResponse().error == null) {
        pitems[pitems.indexWhere((element) => element.id == assetLog.id)] = assetLog;
        notifyListeners();
      }

      return response.getBaseResponse();
    } catch (error) {
      return BaseAPIResponse(error.toString());
    }
  }
}
