import 'package:asset_flutter/content/pages/portfolio/portfolio_page.dart';
import 'package:asset_flutter/utils/extensions.dart';

class Subscription {
  late String name;
  String? description;
  late DateTime billDate;
  late BillCycle billCycle;
  late double price;
  late String currency;
  String? image;
  late int color;

  Subscription(
    this.name, this.description, this.billDate, this.billCycle, 
    this.price, this.currency, this.image, this.color
  );

  Subscription.empty(){
    name = "";
    billDate = DateTime.now();
    billCycle = BillCycle(month: 1);
    price = 0;
    currency = "USD";
    color = TestData.testChartStatsColor[0].value;
  }
}

class BillCycle {
  int day;
  int month;
  int year;

  BillCycle({this.day = 0, this.month = 0, this.year = 0});

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
  final double totalPayment;
  final double monthlyPayment;

  const SubscriptionStats(this.currency, this.totalPayment, this.monthlyPayment);
}