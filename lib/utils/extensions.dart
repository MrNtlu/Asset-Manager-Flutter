import 'package:intl/intl.dart';

extension DoubleExt on double {
  double revertValue() {
    return this < 0 ? abs() : this * -1;
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
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(now);
  }
}

extension StringExt on int {
  String dateDifferencePluralString(String text) {
    return toString() + ' ' + (this > 1 ? text + 's' : text);
  }
}
