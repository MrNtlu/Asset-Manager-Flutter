import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/models/requests/card.dart';
import 'package:asset_flutter/content/providers/common/base_provider.dart';
import 'package:asset_flutter/content/providers/subscription/card.dart';
import 'package:asset_flutter/static/routes.dart';

class CardProvider extends BaseProvider<CreditCard> {

  CreditCard findById(String id) {
    return pitems.firstWhere((element) => element.id == id);
  }

  Future<BaseListResponse<CreditCard>> getCreditCards() async 
    => getList(url: APIRoutes().cardRoutes.cardsByUserID);

  Future<BaseItemResponse<CreditCard>> addCreditCard(CreditCardCreate cardCreate) async 
    => addItem<CreditCardCreate>(cardCreate, url: APIRoutes().cardRoutes.createCard);
  
  Future<BaseAPIResponse> deleteCreditCard(String id) async 
    =>  deleteItem(id, url: APIRoutes().cardRoutes.deleteCardByCardID, deleteItem: findById(id));
}
