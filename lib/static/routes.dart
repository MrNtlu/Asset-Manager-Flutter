import 'dart:io';

class APIRoutes {
  final baseTestURL = Platform.isAndroid ? 'http://10.0.2.2:8080' : 'http://localhost:8080';
  final baseURL = 'https://rocky-reaches-65250.herokuapp.com';

  late final AssetRoutes assetRoutes;
  late final SubscriptionRoutes subscriptionRoutes;
  late final AuthRoutes authRoutes;
  late final UserRoutes userRoutes;

  APIRoutes._privateConstructor() {
    assetRoutes = AssetRoutes(baseURL: baseURL);
    subscriptionRoutes = SubscriptionRoutes(baseURL: baseURL);
    authRoutes = AuthRoutes(baseURL: baseURL);
    userRoutes = UserRoutes(baseURL: baseURL);
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

  AuthRoutes({baseURL}) {
    _baseAuthURL = baseURL + '/auth';

    login = _baseAuthURL + '/login';
    register = _baseAuthURL + '/register';
    logout = _baseAuthURL + '/logout';
  }
}

class UserRoutes {
  late String _baseUserURL;

  late String forgotPassword;
  late String changePassword;
  late String changeCurrency;
  late String deleteUser;

  UserRoutes({baseURL}) {
    _baseUserURL = baseURL + '/user';

    forgotPassword = _baseUserURL + '/forgot-password';
    changePassword = _baseUserURL + '/change-password';
    changeCurrency = _baseUserURL + '/change-currency';
    deleteUser = _baseUserURL;
  }
}

class AssetRoutes {
  late final String _baseAssetURL;

  late final String investingsByType;
  late final String assetsByUserID;
  late final String assetLogsByUserID;
  late final String assetStatsByUserID;
  late final String assetStatsByAssetAndUserID;
  late final String createAsset;
  late final String updateAssetLogByAssetID;
  late final String deleteAllAssetsByUserID;
  late final String deleteAssetLogsByUserID;
  late final String deleteAssetLogByLogID;

  AssetRoutes({baseURL}) {
    _baseAssetURL = baseURL + '/asset';

    investingsByType = baseURL + "/investings";

    assetsByUserID = _baseAssetURL;
    assetLogsByUserID = _baseAssetURL + '/logs';
    assetStatsByUserID = _baseAssetURL + '/stats';
    assetStatsByAssetAndUserID = _baseAssetURL + '/details';

    createAsset = _baseAssetURL;
    updateAssetLogByAssetID = _baseAssetURL;
    deleteAllAssetsByUserID = _baseAssetURL;
    deleteAssetLogsByUserID = _baseAssetURL + '/logs';
    deleteAssetLogByLogID = _baseAssetURL + '/log';
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
