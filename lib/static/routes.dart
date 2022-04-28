import 'dart:io';

class APIRoutes {
  final baseTestURL = Platform.isAndroid ? 'http://10.0.2.2:8080/api/v1' : 'http://localhost:8080/api/v1';
  final baseURL = 'https://rocky-reaches-65250.herokuapp.com/api/v1';

  late final AssetRoutes assetRoutes;
  late final SubscriptionRoutes subscriptionRoutes;
  late final CardRoutes cardRoutes;
  late final AuthRoutes authRoutes;
  late final UserRoutes userRoutes;
  late final InvestingRoutes investingRoutes;
  late final LogRoutes logRoutes;

  APIRoutes._privateConstructor() {
    assetRoutes = AssetRoutes(baseURL: baseURL);
    subscriptionRoutes = SubscriptionRoutes(baseURL: baseURL);
    cardRoutes = CardRoutes(baseURL: baseURL);
    authRoutes = AuthRoutes(baseURL: baseURL);
    userRoutes = UserRoutes(baseURL: baseURL);
    investingRoutes = InvestingRoutes(baseURL: baseURL);
    logRoutes = LogRoutes(baseURL: baseURL);
  }

  static final APIRoutes _instance = APIRoutes._privateConstructor();

  factory APIRoutes() {
    return _instance;
  }
}

class LogRoutes {
  late String _baseLogURL;

  late String createLog;
  late String investings;
  
  LogRoutes({baseURL}) {
    _baseLogURL = baseURL + '/log';

    createLog = _baseLogURL;
  }
}

class InvestingRoutes {
  late String _baseInvestingURL;

  late String prices;
  late String investings;
  
  InvestingRoutes({baseURL}) {
    _baseInvestingURL = baseURL + '/investings';

    prices = _baseInvestingURL + '/prices';
    investings = _baseInvestingURL;
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

  late String info;
  late String forgotPassword;
  late String changePassword;
  late String changeCurrency;
  late String changeMembership;
  late String deleteUser;

  UserRoutes({baseURL}) {
    _baseUserURL = baseURL + '/user';

    info = _baseUserURL + '/info';
    forgotPassword = _baseUserURL + '/forgot-password';
    changePassword = _baseUserURL + '/change-password';
    changeCurrency = _baseUserURL + '/change-currency';
    changeMembership = _baseUserURL + '/membership';
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
  late final String createAssetLog;
  late final String updateAssetLogByAssetID;

  late final String deleteAssetLogByLogID;
  late final String deleteAssetLogsByUserID;
  late final String deleteAllAssetsByUserID;
  
  late final String dailyAssetStats;

  AssetRoutes({baseURL}) {
    _baseAssetURL = baseURL + '/asset';

    investingsByType = baseURL + "/investings";

    assetsByUserID = _baseAssetURL;
    assetLogsByUserID = _baseAssetURL + '/logs';
    assetStatsByUserID = _baseAssetURL + '/stats';
    dailyAssetStats = _baseAssetURL + '/daily-stats';
    assetStatsByAssetAndUserID = _baseAssetURL + '/details';

    createAsset = _baseAssetURL;
    createAssetLog = _baseAssetURL + '/log';
    updateAssetLogByAssetID = _baseAssetURL;

    deleteAssetLogByLogID = _baseAssetURL + '/log';
    deleteAssetLogsByUserID = _baseAssetURL + '/logs';
    deleteAllAssetsByUserID = _baseAssetURL;
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

class CardRoutes {
  late final String _baseCardURL;
  
  late final String cardsByUserID;
  late final String cardStatsByUserID;
  late final String createCard;
  late final String updateCard;

  late final String deleteCardByCardID;
  late final String deleteCardsByUserID;

  CardRoutes({baseURL}) {
    _baseCardURL = baseURL + '/card';

    cardStatsByUserID = _baseCardURL + '/stats';

    cardsByUserID = _baseCardURL;
    createCard = _baseCardURL;
    updateCard = _baseCardURL;
    deleteCardByCardID = _baseCardURL;
    deleteCardsByUserID = _baseCardURL + '/all';
  }
}
