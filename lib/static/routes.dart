class APIRoutes {
  final baseTestURL = 'http://localhost:8080'; 
  final baseURL = 'https://assetmanager-go.oa.r.appspot.com';

  late final AssetRoutes assetRoutes;
  late final SubscriptionRoutes subscriptionRoutes;

  APIRoutes._privateConstructor() {
    assetRoutes = AssetRoutes(baseURL: baseTestURL);
    subscriptionRoutes = SubscriptionRoutes(baseURL: baseTestURL);
  }

  static final APIRoutes _instance = APIRoutes._privateConstructor();

  factory APIRoutes() {
    return _instance;
  }
}

class AuthRoutes {
  late String _baseAuthURL;

  late String login;
  late String register;
  late String logout;
  late String confirmPasswordReset;

  AuthRoutes({baseURL}) {
    _baseAuthURL = baseURL + '/auth';

    login = _baseAuthURL + '/login';
    register = _baseAuthURL + '/register';
    logout = _baseAuthURL + '/logout';
    confirmPasswordReset = _baseAuthURL + '/confirm-password-reset';
  }
}

class AssetRoutes {
  late final String _baseAssetURL;

  late final String assetsByUserID;
  late final String assetLogsByUserID;
  late final String assetStatsByUserID;
  late final String assetStatsByAssetAndUserID;
  late final String createAsset;
  late final String updateAssetLogByAssetID;
  late final String deleteAllAssetsByUserID;
  late final String deleteAssetLogsByUserID;
  late final String deleteAssetLogsByAssetID;

  AssetRoutes({baseURL}) {
    _baseAssetURL = baseURL + '/asset';

    assetsByUserID = _baseAssetURL;
    assetLogsByUserID = _baseAssetURL + '/logs';
    assetStatsByUserID = _baseAssetURL + '/stats';
    assetStatsByAssetAndUserID = _baseAssetURL + '/details';

    createAsset = _baseAssetURL;
    updateAssetLogByAssetID = _baseAssetURL;
    deleteAllAssetsByUserID = _baseAssetURL;
    deleteAssetLogsByUserID = _baseAssetURL + '/logs';
    deleteAssetLogsByAssetID = _baseAssetURL + '/log';
  }
}

class SubscriptionRoutes {
  late final String _baseSubscriptionURL;

  late final String subscriptionStatsByUserID;
  late final String subscriptionDetails;
  late final String subscriptionsByUserID;
  late final String subscriptionByCardID;
  late final String createSubscription;
  late final String updateSubscription;
  late final String deleteSubscriptionBySubscriptionID;
  late final String deleteSubscriptionsByUserID;

  SubscriptionRoutes({baseURL}) {
    _baseSubscriptionURL = baseURL + '/subscription';

    subscriptionStatsByUserID = _baseSubscriptionURL + '/stats';
    subscriptionDetails = _baseSubscriptionURL + '/details';
    subscriptionsByUserID = _baseSubscriptionURL;
    subscriptionByCardID = _baseSubscriptionURL + '/card';

    createSubscription = _baseSubscriptionURL;
    updateSubscription = _baseSubscriptionURL;
    deleteSubscriptionBySubscriptionID = _baseSubscriptionURL;
    deleteSubscriptionsByUserID = _baseSubscriptionURL + '/all';
  }
}
