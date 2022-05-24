import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/content/providers/wallet/transaction_calendar.dart';
import 'package:flutter/material.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class TransactionCalendar extends StatefulWidget {
  const TransactionCalendar({Key? key}) : super(key: key);

  @override
  State<TransactionCalendar> createState() => _TransactionCalendarState();
}

class _TransactionCalendarState extends State<TransactionCalendar> {
  DetailState _state = DetailState.init;
  late final TransactionCalendarCountsProvider _provider;
  DateTime _focusedDay = DateTime.now();
  DateTime _viewedMonth = DateTime.now();

  void _getTransactionCalendarCounts() {
    _provider.getTransactionCalendarCounts(_viewedMonth).then((response) {
      if (_state != DetailState.disposed) {
        setState(() {
          _state = DetailState.view;
        });
      }
    });
  }

  @override
  void dispose() {
    _state = DetailState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == DetailState.init) {
      _provider = Provider.of<TransactionCalendarCountsProvider>(context);
      _getTransactionCalendarCounts();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime(2021, 5, 1),
      currentDay: _viewedMonth,
      rowHeight: MediaQuery.of(context).size.height / (MediaQuery.of(context).size.height > 850 ? 12 : 13.2),
      lastDay: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 7),
      focusedDay: _focusedDay,
      availableGestures: AvailableGestures.horizontalSwipe,
      calendarFormat: CalendarFormat.month,
      onDaySelected: (selectedDay, focusedDay) {
        print(selectedDay);
        print(focusedDay);
      },
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      eventLoader: (day) {
        final item = _provider.items
            .where((element) => isSameDay(element.time, day));
        if (item.isNotEmpty) {
          return List.filled(item.first.count, null);
        } else {
          return [];
        }
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          if (events.isEmpty) {
            return Container();
          }
          return Positioned(
            bottom: 0,
            right: 4,
            child: Card(
              elevation: 2,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: AppColors().primaryColor,
                  borderRadius: BorderRadius.circular(4)
                ),
                child: Text(
                  events.length > 9 ? "+9" : events.length.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold
                  ),
                )
              ),
            ),
          );
        },
      ),
      headerStyle: HeaderStyle(
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
        titleCentered: true,
        leftChevronIcon: Icon(
          Icons.keyboard_arrow_left_rounded,
          color: AppColors().primaryColor
        ),
        rightChevronIcon: Icon(
          Icons.keyboard_arrow_right_rounded,
          color: AppColors().primaryColor
        )
      ),
      onPageChanged: (date) {
        if (date.month != _viewedMonth.month) {
          _viewedMonth = date;
          _focusedDay = date;
          _getTransactionCalendarCounts();
        }
      },
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        weekendStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      ),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: false,
        selectedDecoration: BoxDecoration(
          color: AppColors().primaryColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(6),
        ),
        selectedTextStyle: const TextStyle(color: Colors.white),
        defaultTextStyle: const TextStyle(color: Colors.black),
        weekendTextStyle: const TextStyle(color: Colors.black),
        outsideTextStyle: const TextStyle(color: Colors.black),
        disabledTextStyle: TextStyle(color: Colors.grey.shade700),
        rowDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(6),
        ),
        markerDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(6),
        ),
        holidayDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(6),
        ),
        disabledDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(6),
        ),
        outsideDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(6),
        ),
        rangeEndDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(6),
        ),
        rangeStartDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(6),
        ),
        withinRangeDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(6),
        ),
        todayDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(6),
        ),
        defaultDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(6),
        ),
        weekendDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(6),
        ),
        canMarkersOverflow: false,
      ),
    );
  }
}
