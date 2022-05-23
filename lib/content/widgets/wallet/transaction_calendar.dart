import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
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
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  DateTime _viewedMonth = DateTime.now();

  void _getTransactionCalendarCounts() {
    setState(() {
      _state = DetailState.loading;
    });

    _provider.getTransactionCalendarCounts(_viewedMonth).then((response) {
      if (_state != ListState.disposed) {
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
    return Card(
      elevation: 2,
      color: AppColors().bgSecondary,
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
          bottomLeft: Radius.circular(6),
          bottomRight: Radius.circular(6),
        )
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if(_state == DetailState.loading)
            SizedBox(
              height: _calendarFormat == CalendarFormat.week ? 125 : 300,
              child: const LoadingView("Loading", textColor: Colors.white),
            ),
            TableCalendar(
              firstDay: DateTime(2021, 5, 1),
              currentDay: _viewedMonth,
              lastDay: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 7),
              focusedDay: _focusedDay,
              availableGestures: AvailableGestures.horizontalSwipe,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              availableCalendarFormats: const {
                CalendarFormat.week: 'Week',
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
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  _focusedDay = DateTime.now();
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  if (events.isEmpty) {
                    return Container();
                  }
                  return Positioned(
                    bottom: 2,
                    right: 4,
                    child: Card(
                      elevation: 2,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: isSameDay(_selectedDay, day)
                              ? AppColors().primaryColor
                              : AppColors().bgAccent,
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
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  formatButtonShowsNext: false,
                  formatButtonDecoration: BoxDecoration(
                    color: AppColors().bgAccent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  formatButtonTextStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  leftChevronIcon: Icon(Icons.keyboard_arrow_left_rounded,
                      color: AppColors().bgAccent),
                  rightChevronIcon: Icon(Icons.keyboard_arrow_right_rounded,
                      color: AppColors().bgAccent)),
              onPageChanged: (date) {
                if (date.month != _viewedMonth.month) {
                  _viewedMonth = date;
                  _focusedDay = date;
                  _getTransactionCalendarCounts();
                }
              },
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                weekendStyle:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              calendarStyle: CalendarStyle(
                isTodayHighlighted: true,
                selectedDecoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(6),
                ),
                selectedTextStyle: const TextStyle(color: Colors.black),
                defaultTextStyle: const TextStyle(color: Colors.white),
                weekendTextStyle: const TextStyle(color: Colors.white),
                outsideTextStyle: const TextStyle(color: Colors.white),
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
                  color: AppColors().bgAccent.withOpacity(0.25),
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
            ),
          ],
        ),
      ),
    );
  }
}
