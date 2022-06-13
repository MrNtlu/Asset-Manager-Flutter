import 'package:asset_flutter/auth/models/requests/user.dart';
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

  void setTheme(bool isDarkTheme) {
    sharedPref?.setBool("theme", isDarkTheme);
  }

  bool isDarkTheme() {
    return _sharedPreference.getBool("theme") ?? false;
  }

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

  void setOAuthLoginCredentials(String token) {
    sharedPref?.setString("refresh_token", token);
  }

  String? getOAuthLoginCredentials() {
    return _sharedPreference.getString("refresh_token");
  }

  void deleteOAuthLoginCredentials(){
    sharedPref?.remove("refresh_token");
  }

  SharedPreferences? get sharedPref => _isInit ? _sharedPreference : null;
}
