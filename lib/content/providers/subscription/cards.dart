import 'dart:convert';
import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/models/requests/card.dart';
import 'package:asset_flutter/content/providers/subscription/card.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CardProvider with ChangeNotifier {
  final List<CreditCard> _items = [];

  List<CreditCard> get items => _items;

  CreditCard findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<BaseListResponse<CreditCard>> getCreditCards() async {
    try {
      _items.clear();
      final response = await http.get(
        Uri.parse(
          APIRoutes().cardRoutes.cardsByUserID
        ),
        headers: UserToken().getBearerToken()
      );

      var baseListResponse = response.getBaseListResponse<CreditCard>();
      _items.addAll(baseListResponse.data);
      notifyListeners();

      return baseListResponse;
    } catch (error) {
      return BaseListResponse(error: error.toString());
    }
  }

  Future<BaseItemResponse<CreditCard>> addCreditCard(CreditCardCreate cardCreate) async {
    try {
      final response = await http.post(
        Uri.parse(APIRoutes().cardRoutes.createCard),
        body: json.encode(cardCreate.convertToJson()),
        headers: UserToken().getBearerToken(),
      );

      var baseItemResponse = response.getBaseItemResponse<CreditCard>();
      var data = baseItemResponse.data;

      if (baseItemResponse.error == null && data != null) {  
        _items.add(data);
        notifyListeners();
      }

      return baseItemResponse;
    }catch(error){
      return BaseItemResponse(error: error.toString(), message: error.toString());
    }
  }

  Future<BaseAPIResponse> deleteCreditCard(String id) async {
    try {
      final response = await http.delete(
        Uri.parse(APIRoutes().cardRoutes.deleteCardByCardID),
        body: json.encode({
          "id": id
        }),
        headers: UserToken().getBearerToken()
      );

      if (response.getBaseResponse().error == null) {
        final deleteItem = findById(id);
        _items.remove(deleteItem);
        notifyListeners();   
      }

      return response.getBaseResponse();
    } catch (error) {
      return BaseAPIResponse(error.toString());
    }
  }
}
