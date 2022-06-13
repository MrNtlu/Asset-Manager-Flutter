
class UserInfo {
  final bool isPremium;
  final bool isLifetimePremium;
  final bool isOAuth;
  final int oAuthType;
  final String email;
  String currency;
  String fcmToken;
  final String investingLimit;
  final String subscriptionLimit;

  UserInfo(this.isPremium, this.isLifetimePremium, this.isOAuth, this.oAuthType, this.email, this.currency, this.fcmToken, this.investingLimit, this.subscriptionLimit);
}