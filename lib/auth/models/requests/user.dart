import 'dart:convert';
import 'package:asset_flutter/auth/models/responses/user.dart';
import 'package:asset_flutter/common/models/json_convert.dart';
import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:http/http.dart' as http;

class Login implements JSONConverter {
  String emailAddress;
  String password;

  Login(this.emailAddress, this.password);

  Future<TokenResponse> login() async {
    try {
      var response = await http.post(
        Uri.parse(APIRoutes().authRoutes.login),
        body: json.encode(convertToJson()),
        headers: {
          "Content-Type": "application/json",
        }
      );

      return TokenResponse(
        code: json.decode(response.body)["code"],
        message: json.decode(response.body)["message"],
        token: json.decode(response.body)["access_token"],
      );
    } catch (error) {
      return TokenResponse(
        code: 400,
        message: error.toString()
      );
    }
  }

  @override
  Map<String, Object> convertToJson() => {
    "email_address": emailAddress,
    "password": password
  }; 
}

class Register implements JSONConverter {
  String emailAddress;
  String currency;
  String password;

  Register(this.emailAddress, this.currency, this.password);

  Future<BaseAPIResponse> register() async {
    try {
      var response = await http.post(
        Uri.parse(APIRoutes().authRoutes.register),
        body: json.encode(convertToJson()),
        headers: {
          "Content-Type": "application/json",
        }
      );

      return BaseAPIResponse(jsonDecode(response.body)["error"]);
    } catch (error) {
      return BaseAPIResponse(error.toString());
    }
  }

  @override
  Map<String, Object> convertToJson() => {
     "email_address": emailAddress, 
     "currency": currency,
     "password": password
  };
}

class ChangePassword {
  final String oldPassword;
  final String newPassword;

  const ChangePassword(this.oldPassword, this.newPassword);
}

class ChangeCurrency {
  final String currency;

  const ChangeCurrency(this.currency);
}

class ForgotPassword {
  final String emailAddress;

  const ForgotPassword(this.emailAddress);
}
