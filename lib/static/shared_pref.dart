import 'package:asset_flutter/auth/models/requests/user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  var _isInit = false;
  late final SharedPreferences _sharedPreference;

  SharedPref._privateConstructor();

  Future init() async {
    if (!_isInit) {
      _sharedPreference = await SharedPreferences.getInstance().then((value) {
        _isInit = true;
        return value;
      });
    }
  }

  static final SharedPref _instance = SharedPref._privateConstructor();

  factory SharedPref() {
    return _instance;
  }

  //Dark Theme
  void setTheme(bool isDarkTheme) {
    sharedPref?.setBool("theme", isDarkTheme);
  }

  bool isDarkTheme() {
    return _sharedPreference.getBool("theme") ?? false;
  }

  //Login Credentials
  void setLoginCredentials(String email, String password) {
    sharedPref?.setString("email_address", email);
    sharedPref?.setString("password", password);
  }

  Map<bool, Login?> getLoginCredentials() {
    final String? email = _sharedPreference.getString("email_address");
    final String? password = _sharedPreference.getString("password");
    return {
      (email != null && password != null) : (email != null && password != null) ? Login(email, password) : null
    };
  }

  void deleteLoginCredentials(){
    sharedPref?.remove("email_address");
    sharedPref?.remove("password");
  }

  //OAuth Refresh Token
  void setOAuthLoginCredentials(String token) {
    sharedPref?.setString("refresh_token", token);
  }

  String? getOAuthLoginCredentials() {
    return _sharedPreference.getString("refresh_token");
  }

  void deleteOAuthLoginCredentials(){
    sharedPref?.remove("refresh_token");
  }

  //Default Tab
  void setDefaultTab(int tabPosition) {
    sharedPref?.setInt("default_tab", tabPosition);
  }

  int getDefaultTab() {
    return _sharedPreference.getInt("default_tab") ?? 0;
  }

  //Introduction
  void setIsIntroductionDeleted(bool isIntroductionDeleted) {
    sharedPref?.setBool("is_introduction_deleted", isIntroductionDeleted);
  }

  bool getIsIntroductionDeleted() {
    return _sharedPreference.getBool("is_introduction_deleted") ?? false;
  }

  //Watchlist
  void setIsWatchlistHidden(bool isHidden) {
    sharedPref?.setBool("is_watchlist_hidden", isHidden);
  }

  bool getIsWatchlistHidden() {
    return _sharedPreference.getBool("is_watchlist_hidden") ?? false;
  }

  //Watchlist Color
  void setWatchlistColor(int _color) {
    sharedPref?.setInt("watchlist_color", _color);
  }

  int getWatchlistColor() {
    return _sharedPreference.getInt("watchlist_color") ?? const Color(0xFF292D32).value;
  }

  //Portfolio Color
  void setPortfolioColor(int _color) {
    sharedPref?.setInt("portfolio_color", _color);
  }

  int getPortfolioColor() {
    return _sharedPreference.getInt("portfolio_color") ?? const Color(0xFF00579B).value;
  }

  SharedPreferences? get sharedPref => _isInit ? _sharedPreference : null;
}
