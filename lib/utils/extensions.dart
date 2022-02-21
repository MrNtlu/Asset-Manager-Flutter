import 'dart:convert';

import 'package:asset_flutter/common/models/response.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

extension DoubleExt on double {
  double revertValue() {
    return this == 0 ? 0 : (this < 0 ? abs() : this * -1);
  }
}

extension NumExt on num {
  String numToString(){
    return toDouble().toStringAsFixed(2);
  }
}

extension DateTimeExt on DateTime {
  String dateToDaysAgo() {
    final dayDiff = DateTime.now().difference(this).inDays;
    final days = (dayDiff % 30);
    final months = (dayDiff / 30).floor();
    final years = (dayDiff / 365).floor();

    if (dayDiff >= 30 && dayDiff < 365) {
      if (dayDiff % 30 != 0) {
        return (months.dateDifferencePluralString('month') + ' ' + days.dateDifferencePluralString('day') + " ago.");
      }
      return (months.toString() + " months ago.");

    }else if (dayDiff >= 365) {
      if ((dayDiff - 365) / 30 != 0) {
        final months = ((dayDiff - 365) / 30).floor();
        return (years.dateDifferencePluralString('year') + ' ' + months.dateDifferencePluralString('month') + " ago.");
      }

      return (years.dateDifferencePluralString('year') + " ago.");
    }
    return dayDiff.dateDifferencePluralString('day') + ' ago.';
  }

  String dateToFormatDate() {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(this);
  }

  String dateToJSONFormat(){
    final DateFormat formatter = DateFormat("yyyy-MM-dd'T'hh:mm:ss'Z'");
    return formatter.format(this);
  }
}

extension IntExt on int {
  String dateDifferencePluralString(String text) {
    return toString() + ' ' + (this > 1 ? text + 's' : text);
  }
}

extension StringExt on String {
  bool isEmailValid() {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(this);
  }
}

extension ResponseExt on Response {
  BaseAPIResponse getBaseResponse() => BaseAPIResponse(
    json.decode(body)["error"], 
  );

  BaseItemResponse<T> getBaseItemResponse<T>() => BaseItemResponse<T>(
    message: json.decode(body)["message"],
    response: json.decode(body)["data"],
  );

  BasePaginationResponse<T> getBasePaginationResponse<T>() => BasePaginationResponse(
    response: json.decode(body)["data"],
    canNextPage: (json.decode(body)["pagination"]["next"] ?? 0) > 0,
    error: json.decode(body)["error"]
  );

  BaseListResponse<T> getBaseListResponse<T>() => BaseListResponse<T>(
    message: json.decode(body)["message"],
    response: json.decode(body)["data"],
    code: json.decode(body)["code"],
    error: json.decode(body)["error"]
  );
}
