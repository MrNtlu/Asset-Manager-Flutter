import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/models/responses/subscription.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubscriptionDetailsProvider with ChangeNotifier {
  SubscriptionDetails? subscriptionDetails;

  Future<BaseItemResponse<SubscriptionDetails>> getSubscriptionDetails(String id) async {
    try {
      final response = await http.get(
        Uri.parse(APIRoutes().subscriptionRoutes.subscriptionDetails + "?id=$id"),
        headers: UserToken().getBearerToken()
      );

      subscriptionDetails = response.getBaseItemResponse<SubscriptionDetails>().data;
      notifyListeners();

      return response.getBaseItemResponse<SubscriptionDetails>();
    } catch (error) {
      return BaseItemResponse(message: error.toString());
    }
  }
}