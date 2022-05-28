import 'dart:convert';

import 'package:asset_flutter/common/models/json_convert.dart';
import 'package:flutter/material.dart';
import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:http/http.dart' as http;

class BaseProvider<T> with ChangeNotifier {
  @protected
  final List<T> pitems = [];

  List<T> get items => pitems;

  @protected
  Future<BaseListResponse<T>> getList<R>({required String url}) async {
    try {
      pitems.clear();
      final response = await http.get(
        Uri.parse(url),
        headers: UserToken().getBearerToken()
      );

      var baseListResponse = response.getBaseListResponse<T>();
      pitems.addAll(baseListResponse.data);
      notifyListeners();


      return baseListResponse;
    } catch(error) {
      return BaseListResponse(error: error.toString());
    }
  }

  @protected
  Future<BaseItemResponse<T>> addItem<C extends JSONConverter>(C _createObject, {required String url}) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(_createObject.convertToJson()),
        headers: UserToken().getBearerToken()
      );

      var baseItemResponse = response.getBaseItemResponse<T>();
      var data = baseItemResponse.data;

      if (baseItemResponse.error == null && data != null) {  
        pitems.add(data);
        notifyListeners();
      }

      return baseItemResponse;
    } catch(error) {
      return BaseItemResponse(error: error.toString(), message: error.toString());
    }
  }

  @protected
  Future<BaseAPIResponse> deleteItem(String _id, {
    required String url,
    required T deleteItem
  }) async {
    try {
      final response = await http.delete(
        Uri.parse(url),
        body: json.encode({
          "id": _id
        }),
        headers: UserToken().getBearerToken()
      );

      if (response.getBaseResponse().error == null) {
        pitems.remove(deleteItem);
        notifyListeners();   
      }

      return response.getBaseResponse();
    } catch (error) {
      return BaseAPIResponse(error.toString());
    }
  }
}