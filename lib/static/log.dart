import 'dart:convert';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:http/http.dart' as http;

class Log {
  void createLog(String message) async {
    http.post(
      Uri.parse(APIRoutes().logRoutes.createLog),
      body: json.encode({
        "log": message,
        "log_type": 1
      }),
      headers: UserToken().getBearerToken()
    );
  }

  Log._privateConstructor();

  static final Log _instance = Log._privateConstructor();

  factory Log() {
    return _instance;
  }
}