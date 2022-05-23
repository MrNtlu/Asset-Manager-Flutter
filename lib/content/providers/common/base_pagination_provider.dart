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
  Future<BasePaginationResponse<T>> getList<R>({required String url}) async {
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
}