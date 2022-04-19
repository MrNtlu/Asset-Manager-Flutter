import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/providers/subscription/card.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CardProvider with ChangeNotifier {
  final List<CreditCard> _items = [];

  List<CreditCard> get items => _items;

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
}
