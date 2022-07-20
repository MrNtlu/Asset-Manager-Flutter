import 'dart:io';

class APIRoutes {
  // final baseURL = Platform.isAndroid ? 'http://10.0.2.2:8080/api/v1' : 'http://localhost:8080/api/v1';
  final baseURL = 'https://rocky-reaches-65250.herokuapp.com/api/v1';

  late final AssetRoutes assetRoutes;
  late final SubscriptionRoutes subscriptionRoutes;
  late final TransactionRoutes transactionRoutes;
  late final CardRoutes cardRoutes;
  late final BankAccountRoutes bankAccRoutes;
  late final AuthRoutes authRoutes;
  late final OAuthRoutes oauthRoutes;
  late final UserRoutes userRoutes;
  late final InvestingRoutes investingRoutes;
  late final LogRoutes logRoutes;
  late final FavouriteInvestingRoutes favInvestingRoutes;

  APIRoutes._privateConstructor() {
    assetRoutes = AssetRoutes(baseURL: baseURL);
    subscriptionRoutes = SubscriptionRoutes(baseURL: baseURL);
    transactionRoutes = TransactionRoutes(baseURL: baseURL);
    cardRoutes = CardRoutes(baseURL: baseURL);
    bankAccRoutes = BankAccountRoutes(baseURL: baseURL);
    authRoutes = AuthRoutes(baseURL: baseURL);
    oauthRoutes = OAuthRoutes(baseURL: baseURL);
    userRoutes = UserRoutes(baseURL: baseURL);
    investingRoutes = InvestingRoutes(baseURL: baseURL);
    logRoutes = LogRoutes(baseURL: baseURL);
    favInvestingRoutes = FavouriteInvestingRoutes(baseURL: baseURL);
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

class OAuthRoutes {
  late String _baseOAuthURL;

  late String google;
  late String apple;

  OAuthRoutes({baseURL}) {
    _baseOAuthURL = baseURL + '/oauth';

    google = _baseOAuthURL + '/google';
    apple = _baseOAuthURL + '/apple';
  }
}

class UserRoutes {
  late String _baseUserURL;

  late String info;
  late String forgotPassword;
  late String changePassword;
  late String changeCurrency;
  late String changeNotification;
  late String changeMembership;
  late String updateFCMToken;
  late String deleteUser;

  UserRoutes({baseURL}) {
    _baseUserURL = baseURL + '/user';

    info = _baseUserURL + '/info';
    forgotPassword = _baseUserURL + '/forgot-password';
    changePassword = _baseUserURL + '/change-password';
    changeCurrency = _baseUserURL + '/change-currency';
    changeNotification = _baseUserURL + '/change-notification';
    updateFCMToken = _baseUserURL + '/update-token';
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

class TransactionRoutes {
  late final String _baseTransactionURL;

  late final String transactionStats;
  late final String totalTransactionByInterval;
  late final String calendarTransactionCount;
  late final String transactionByUserIDAndFilterSort;

  late final String updateTransaction;
  late final String createTransaction;
  late final String deleteTransactionByTransactionID;
  late final String deleteAllTransactionsByUserID;

  TransactionRoutes({baseURL}) {
    _baseTransactionURL = baseURL + "/transaction";

    transactionStats = _baseTransactionURL + "/stats";
    totalTransactionByInterval = _baseTransactionURL + "/total";
    transactionByUserIDAndFilterSort = _baseTransactionURL;

    updateTransaction = _baseTransactionURL;
    createTransaction = _baseTransactionURL;
    deleteTransactionByTransactionID = _baseTransactionURL;
    deleteAllTransactionsByUserID = _baseTransactionURL + "/all";
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

class BankAccountRoutes {
  late final String _baseBankAccountURL;
  
  late final String bankAccsByUserID;
  late final String bankAccStatsByUserID;
  late final String createBankAcc;
  late final String updateBankAcc;

  late final String deleteBankAccByBankAccID;
  late final String deleteBankAccsByUserID;

  BankAccountRoutes({baseURL}) {
    _baseBankAccountURL = baseURL + '/ba';

    bankAccStatsByUserID = _baseBankAccountURL + '/stats';

    bankAccsByUserID = _baseBankAccountURL;
    createBankAcc = _baseBankAccountURL;
    updateBankAcc = _baseBankAccountURL;
    deleteBankAccByBankAccID = _baseBankAccountURL;
    deleteBankAccsByUserID = _baseBankAccountURL + '/all';
  }
}

class FavouriteInvestingRoutes {
  late String _baseFavInvestingURL;

  late String favouriteInvestings;
  late String createFavouriteInvesting;
  late String updateFavouriteInvestingOrder;

  late String deleteFavouriteInvesting;
  late String deleteAllFavouriteInvestings;
  
  FavouriteInvestingRoutes({baseURL}) {
    _baseFavInvestingURL = baseURL + '/watchlist';

    favouriteInvestings = _baseFavInvestingURL;
    createFavouriteInvesting = _baseFavInvestingURL;
    updateFavouriteInvestingOrder = _baseFavInvestingURL;
    deleteFavouriteInvesting = _baseFavInvestingURL;
    deleteAllFavouriteInvestings = _baseFavInvestingURL + '/all';
  }
}