import 'dart:convert';

import 'package:asset_flutter/common/models/json_convert.dart';
import 'package:flutter/material.dart';
import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:http/http.dart' as http;

class BasePaginationProvider<T> with ChangeNotifier {
  @protected
  final List<T> pitems = [];

  List<T> get items => pitems;

  @protected
  Future<BasePaginationResponse<T>> getList({required String url}) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: UserToken().getBearerToken()
      );

      var basePaginationResponse = response.getBasePaginationResponse<T>();
      pitems.addAll(basePaginationResponse.data);
      notifyListeners();


      return basePaginationResponse;
    } catch(error) {
      return BasePaginationResponse(error: error.toString(), canNextPage: false);
    }
  }

  @protected
  Future<BaseAPIResponse> createItem<C extends JSONConverter>(C _createObject, {required String url}) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(_createObject.convertToJson()),
        headers: UserToken().getBearerToken(),
      );
      
      return response.getBaseResponse();
    } catch (error) {
      return BaseAPIResponse(error.toString());
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