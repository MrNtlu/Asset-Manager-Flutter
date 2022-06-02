import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/models/responses/subscription.dart';
import 'package:asset_flutter/content/providers/common/base_item_provider.dart';
import 'package:asset_flutter/static/routes.dart';

class SubscriptionDetailsProvider extends BaseItemProvider<SubscriptionDetails> {

  Future<BaseItemResponse<SubscriptionDetails>> getSubscriptionDetails(String id) async
    => getItem(url: APIRoutes().subscriptionRoutes.subscriptionDetails + "?id=$id");
}