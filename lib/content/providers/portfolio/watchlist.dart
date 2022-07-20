import 'dart:convert';

import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/models/requests/favourite_investing.dart';
import 'package:asset_flutter/content/models/responses/favourite_investment.dart';
import 'package:asset_flutter/content/providers/common/base_provider.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:http/http.dart' as http;

class WatchListProvider extends BaseProvider<FavouriteInvesting> {

  FavouriteInvesting findById(String id) {
    return pitems.firstWhere((element) => element.id == id);
  }

  void updatePriority() {
    for (var i = 0; i < pitems.length; i++) {
      pitems[i].priority = i + 1;
    }
    notifyListeners();
  }

  void updateOrder(List<FavouriteInvesting> newList){
    pitems.clear();
    pitems.addAll(newList);
    notifyListeners();
  }

  Future<BaseListResponse<FavouriteInvesting>> getWatchlist() async 
    => getList(url: APIRoutes().favInvestingRoutes.favouriteInvestings);

  Future<BaseAPIResponse> addfavInvesting(FavouriteInvestingCreate favInvestingCreate) async {
    try {
      final response = await http.post(
        Uri.parse(APIRoutes().favInvestingRoutes.createFavouriteInvesting),
        body: json.encode(favInvestingCreate.convertToJson()),
        headers: UserToken().getBearerToken()
      );

      return response.getBaseResponse();
    } catch (error) {
      return BaseAPIResponse(error.toString());
    }
  }
  
  Future<BaseAPIResponse> deleteFavInvesting(String id) async 
    =>  deleteItem(id, url: APIRoutes().favInvestingRoutes.deleteFavouriteInvesting, deleteItem: findById(id));

  Future<BaseAPIResponse> deleteAllFavInvestings() async 
    => deleteAllItems(url: APIRoutes().favInvestingRoutes.deleteAllFavouriteInvestings);
}
