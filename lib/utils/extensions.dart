import 'dart:convert';
import 'package:asset_flutter/common/models/response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

extension ColorExt on Color {
  Color getThemeColor() => ThemeData.estimateBrightnessForColor(this) == Brightness.light ? Colors.black : Colors.white;
}

extension DoubleExt on double {
  double revertValue() {
    return this == 0 ? 0 : (this < 0 ? abs() : this * -1);
  }
}

extension NumExt on num {
  String numToString(){
    if (abs() >= 1) {
      return toDouble().toStringAsFixed(2);
    } else if (this == 0) {
      return toDouble().toString();
    }
    
    final List<String> numberHolder = [];
    int count = 0;
    bool isDecimalStarted = false;
    for (var char in toDouble().toString().split(".")[1].characters) {
      count += 1;
      if (int.parse(char) > 0) {
        isDecimalStarted = true;
        numberHolder.clear();
      } else {
        numberHolder.add(char);
      }

      if (isDecimalStarted && numberHolder.length > 2) {
        count -= numberHolder.length;
        break;
      } else if (count > 5) {
        break;
      }
    }

    return toDouble().toStringAsFixed(count);
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

    } else if (dayDiff >= 365) {
      if ((dayDiff - 365) / 30 != 0) {
        final months = ((dayDiff - 365) / 30).floor();
        return (years.dateDifferencePluralString('year') + ' ' + months.dateDifferencePluralString('month') + " ago.");
      }

      return (years.dateDifferencePluralString('year') + " ago.");
    }

    if (dayDiff == 0) {
      return 'Today';
    } else if (dayDiff == 1) {
      return "Yesterday";
    }
    return dayDiff.dateDifferencePluralString('day') + ' ago.';
  }

  String dateToDaysLeft() {
    final dayDiff = difference(DateTime.now()).inDays;
    final months = (dayDiff / 30).floor();
    final years = (dayDiff / 365).floor();

    if (dayDiff >= 30 && dayDiff < 365) {
      if (dayDiff % 30 != 0) {
        return (months.dateDifferencePluralString('month') + " left");
      }
      return (months.toString() + " months ago.");

    } else if (dayDiff >= 365) {
      if ((dayDiff - 365) / 30 != 0) {
        final months = ((dayDiff - 365) / 30).floor();
        return (years.dateDifferencePluralString('year') + ' ' + months.dateDifferencePluralString('month') + " left");
      }

      return (years.dateDifferencePluralString('year') + " left");
    } else if (dayDiff == 1) {
      return "Tomorrow";
    } else if (dayDiff == 0) {
      return "Today";
    }
    return dayDiff.dateDifferencePluralString('day') + ' left';
  }

  String dateToInfoDate() {
    final dayDiff = difference(DateTime.now()).inDays;

    if (dayDiff == 1) {
      return "Tomorrow";
    } else if (isSameDay(DateTime.now(), this)) {
      return "Today";
    } else {
      return dateToHumanDate();
    }
  }

  String dateToTime() {
    final DateFormat formatter = DateFormat("HH:mm");
    return formatter.format(this);
  }

  String dateToFormatDate() {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(this);
  }

  String dateToHumanDate() {
    final DateFormat formatter = DateFormat('dd MMM yy');
    return formatter.format(this);
  }

  String dateToDateTime() {
    final DateFormat formatter = DateFormat("dd MMM HH:mm");
    return formatter.format(this);
  }

  String dateToFullDateTime() {
    final DateFormat formatter = DateFormat("dd MMM yy HH:mm");
    return formatter.format(this);
  }

  String dateToJSONFormat() {
    final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    return formatter.format(this);
  }

  String dateToSimpleJSONFormat() {
    final DateFormat formatter = DateFormat("yyyy-MM-dd");
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

  String getCurrencyFromString() {
    try {
      var format = NumberFormat.simpleCurrency(name: this);
      return format.currencySymbol.isNotEmpty ? format.currencySymbol : this;
    } catch(_) {
      return this;
    }
  }
}

extension ResponseExt on Response {
  AssetResponse getStatsResponse() => AssetResponse(
    message: json.decode(body)["message"],
    response: json.decode(body)["data"],
    code: json.decode(body)["code"],
    error: json.decode(body)["error"],
    statsResponse: json.decode(body)["stats"]
  );

  SubscriptionResponse getSubscriptionStatsResponse() => SubscriptionResponse(
    message: json.decode(body)["message"],
    response: json.decode(body)["data"],
    code: json.decode(body)["code"],
    error: json.decode(body)["error"],
    statsResponse: json.decode(body)["stats"]
  );

  BaseAPIResponse getBaseResponse() => BaseAPIResponse(
    json.decode(body)["error"], 
  );

  BaseItemResponse<T> getBaseItemResponse<T>() => BaseItemResponse<T>(
    message: json.decode(body)["message"] ?? '',
    error: json.decode(body)["error"],
    response: json.decode(body)["data"],
  );

  BasePaginationResponse<T> getBasePaginationResponse<T>() => BasePaginationResponse(
    response: json.decode(body)["data"],
    canNextPage: (json.decode(body)["pagination"]?["next"] ?? 0) > 0,
    error: json.decode(body)["error"]
  );

  BaseListResponse<T> getBaseListResponse<T>() => BaseListResponse<T>(
    message: json.decode(body)["message"],
    response: json.decode(body)["data"],
    code: json.decode(body)["code"],
    error: json.decode(body)["error"]
  );
}
