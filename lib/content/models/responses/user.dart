
class UserInfo {
  final bool isPremium;
  final bool isLifetimePremium;
  final bool isOAuth;
  bool appNotification;
  final int oAuthType;
  final String email;
  String currency;
  String fcmToken;
  final String investingLimit;
  final String subscriptionLimit;
  final String watchlistLimit;

  UserInfo(
    this.isPremium, this.isLifetimePremium, this.isOAuth, this.appNotification, 
    this.oAuthType, this.email, this.currency, this.fcmToken, this.investingLimit, 
    this.subscriptionLimit, this.watchlistLimit
  );
}