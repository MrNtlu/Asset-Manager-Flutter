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
}