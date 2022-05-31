import 'dart:convert';
import 'package:asset_flutter/common/models/response.dart';
import 'package:asset_flutter/content/models/requests/transaction.dart';
import 'package:asset_flutter/content/providers/common/base_pagination_provider.dart';
import 'package:asset_flutter/content/providers/wallet/transaction.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:http/http.dart' as http;

class TransactionsProvider extends BasePaginationProvider<Transaction> {

  Transaction findById(String id) {
    return pitems.firstWhere((element) => element.id == id);
  }

  Future<BasePaginationResponse<Transaction>> getTransactions({
    required TransactionSortFilter sortFilter
  }) async {
    if (sortFilter.page == 1) {
      pitems.clear();
    }

    String apiQuery = (
      "page=${sortFilter.page}&sort=${sortFilter.sort}&type=${sortFilter.sortType}" +
      (sortFilter.category != null ? "&category=${sortFilter.category}" : '') +
      (sortFilter.startDate != null ? "&start_date=${sortFilter.startDate?.dateToSimpleJSONFormat()}" : '') +
      (sortFilter.endDate != null ? "&end_date=${sortFilter.endDate?.dateToSimpleJSONFormat()}" : '') +
      (sortFilter.bankAccID != null ? "&bank_id=${sortFilter.bankAccID}" : '') +
      (sortFilter.cardID != null ? "&card_id=${sortFilter.cardID}" : '')
    );

    return getList(url: APIRoutes().transactionRoutes.transactionByUserIDAndFilterSort + "?" + apiQuery);
  }

  Future<BaseAPIResponse> createTransaction(TransactionCreate transactionCreate) async {
    try {
      final response = await http.post(
        Uri.parse(APIRoutes().transactionRoutes.createTransaction),
        body: json.encode(transactionCreate.convertToJson()),
        headers: UserToken().getBearerToken()
      );

      return response.getBaseResponse();
    } catch(error) {
      return BaseAPIResponse(error.toString());
    }
  }

  Future<BaseAPIResponse> deleteTransaction(String id) async {
    try {
      final response = await http.delete(
        Uri.parse(APIRoutes().transactionRoutes.deleteTransactionByTransactionID),
        body: json.encode({
          "id": id
        }),
        headers: UserToken().getBearerToken()
      );

      if (response.getBaseResponse().error == null) {
        pitems.removeWhere((element) => element.id == id);
        notifyListeners();
      }

      return response.getBaseResponse();
    } catch (error) {
      return BaseAPIResponse(error.toString());
    }
  }

  Future<BaseItemResponse<Transaction>> updateTransaction(TransactionUpdate update) async {
    try {
      final response = await http.put(
        Uri.parse(APIRoutes().transactionRoutes.updateTransaction),
        body: json.encode(update.convertToJson()),
        headers: UserToken().getBearerToken()
      );

      var baseItemResponse = response.getBaseItemResponse<Transaction>();
      var data = baseItemResponse.data;

      if (baseItemResponse.error == null && data != null) {
        final item = pitems.firstWhere((element) => element.id == data.id);
        item.title = data.title;
        item.description = data.description;
        item.category = data.category;
        item.price = data.price;
        item.currency = data.currency;
        item.transactionMethod = data.transactionMethod;
        item.transactionDate = data.transactionDate;

        notifyListeners();
      }

      return baseItemResponse;
    } catch (error) {
      return BaseItemResponse(
          message: error.toString(), error: error.toString());
    }
  }
}
