class APIRoutes {
  final baseURL = 'assetmanager-go.oa.r.appspot.com';

  final AssetRoutes assetRoutes =
      AssetRoutes(baseURL: 'assetmanager-go.oa.r.appspot.com');

  APIRoutes._privateConstructor();

  static final APIRoutes _instance = APIRoutes._privateConstructor();

  factory APIRoutes() {
    return _instance;
  }
}

class AssetRoutes {
  late String baseAssetURL;

  late String assetsByUserID;
  late String assetLogsByUserID;
  late String assetStatsByUserID;
  late String assetStatsByAssetAndUserID;
  late String createAsset;
  late String updateAssetLogByAssetID;
  late String deleteAllAssetsByUserID;
  late String deleteAssetLogsByUserID;
  late String deleteAssetLogsByAssetID;

  AssetRoutes({baseURL}) {
    baseAssetURL = baseURL + '/asset';

    assetsByUserID = baseAssetURL;
    assetLogsByUserID = baseAssetURL + '/logs';
    assetStatsByUserID = baseAssetURL + '/stats';
    assetStatsByAssetAndUserID = baseAssetURL + '/details';

    createAsset = baseAssetURL;
    updateAssetLogByAssetID = baseAssetURL;
    deleteAllAssetsByUserID = baseAssetURL;
    deleteAssetLogsByUserID = baseAssetURL + '/logs';
    deleteAssetLogsByAssetID = baseAssetURL + '/log';
  }
}

class SubscriptionRoutes {
  late String baseSubscriptionURL;

  late String subscriptionStatsByUserID;
  late String subscriptionDetails;
  late String subscriptionsByUserID;
  late String subscriptionByCardID;
  late String createSubscription;
  late String updateSubscription;
  late String deleteSubscriptionBySubscriptionID;
  late String deleteSubscriptionsByUserID;

  SubscriptionRoutes({baseURL}) {
    baseSubscriptionURL = baseURL + '/subscription';

    subscriptionStatsByUserID = baseSubscriptionURL + '/stats';
    subscriptionDetails = baseSubscriptionURL + '/details';
    subscriptionStatsByUserID = baseSubscriptionURL;
    subscriptionByCardID = baseSubscriptionURL + '/card';

    createSubscription = baseSubscriptionURL;
    updateSubscription = baseSubscriptionURL;
    deleteSubscriptionBySubscriptionID = baseSubscriptionURL;
    deleteSubscriptionsByUserID = baseSubscriptionURL + '/all';
  }
}
