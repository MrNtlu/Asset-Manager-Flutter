import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BaseItemProvider<T> with ChangeNotifier {
  @protected
  T? _item;

  T? get item => _item;

  set setItem(T item){
    _item = item;
  }

  Future<BaseItemResponse<T>> getItem({required String url}) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: UserToken().getBearerToken()
      );

      var baseItemResponse = response.getBaseItemResponse<T>();
      var data = baseItemResponse.data;

      if (data != null) {
        _item = data;

        notifyListeners();
      }

      return baseItemResponse;
    } catch (error) {
      return BaseItemResponse(message: error.toString());
    }
  }
}