import 'package:asset_flutter/common/models/json_convert.dart';
import 'package:asset_flutter/utils/extensions.dart';

class SubscriptionCard {
  final String name;
  final String lastDigits;
  final String type;

  const SubscriptionCard(this.name, this.lastDigits, this.type);
}

class SubscriptionAccount implements JSONConverter {
  String email;
  String? password;

  SubscriptionAccount(this.email, this.password);

  @override
  Map<String, Object> convertToJson() => {
    "email_address": email,
    if(password != null && password!.isNotEmpty)
    "password": password!
  };
}

class SubscriptionDetails {
  final num monthlyPayment;
  final num totalpayment;
  final SubscriptionCard? card;

  SubscriptionDetails(this.monthlyPayment, this.totalpayment, this.card);
}

class BillCycle implements JSONConverter{
  int day;
  int month;
  int year;

  BillCycle({this.day = 0, this.month = 0, this.year = 0});
  
  @override
  // ignore: hash_and_equals
  bool operator == (Object other) =>
    other is BillCycle &&
    runtimeType == other.runtimeType &&
    day == other.day &&
    month == other.month && 
    year == other.year;

  BillCycle copyWith({
    int? day,
    int? month,
    int? year
  }) => BillCycle(day: day ?? this.day, month: month ?? this.month, year: year ?? this.year);

  @override
  Map<String, Object> convertToJson() => {
    "day": day,
    "month": month,
    "year": year
  };

  Map<int, String> getBillCycle() {
    if (day != 0) {
      return {day: "Day"};
    }else if (month != 0) {
      return {month: "Month"};
    }else if (year != 0) { 
      return {year: "Year"};
    }
    return {1: "Month"};
  }

  String handleBillCycleString() {
    if(day != 0){
      return "Every " + day.dateDifferencePluralString("day");
    }else if (month != 0) {
      return "Every " + month.dateDifferencePluralString("month");
    }else {
      return "Every " + year.dateDifferencePluralString("year") ;
    }
  }

  int getBillCycleFrequency() {
    if (day != 0) {
      return day;
    }else if (month != 0) {
      return month;
    }else if (year != 0) { 
      return year;
    }

    return -1;
  }

  setBillCycleFrequency(int cycle) {
    if (day != 0) {
      day = cycle;
    }else if (month != 0) {
      month = cycle;
    }else if (year != 0) { 
      year = cycle;
    }
  }

  setBillCycleType(String type) {
    if (type == "Day") {
      day = getBillCycleFrequency();
    }else if (type == "Month") {
      month = getBillCycleFrequency();
    }else if (type == "Year") { 
      year = getBillCycleFrequency();
    }
    _setOthersNull(type);
  }

  _setOthersNull(String type){
    if (type == "Day") {
      month = 0;
      year = 0;
    }else if (type == "Month") {
      day = 0;
      year = 0;
    }else if (type == "Year") { 
      month = 0;
      day = 0;
    }
  }
}

class SubscriptionStats {
  final String currency;
  final num monthlyPayment;
  final num totalPayment;

  const SubscriptionStats(this.currency, this.monthlyPayment, this.totalPayment,);
}