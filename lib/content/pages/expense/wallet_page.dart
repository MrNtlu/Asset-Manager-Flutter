import 'dart:io';

import 'package:asset_flutter/common/widgets/add_elevated_button.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final List<bool> isSelected = [true, false];
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  final testEventList = {
    DateTime.now(): [
      "1"
    ],
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1): [
      "1",
      "2",
      "3",
      "3",
      "3",
      "3",
      "3",
      "3",
    ],
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 12): [
      "1",
      "2",
      "3",
      "3",
      "3",
      "123",
      "3",
      "3",
      "3",
      "asdasd",
    ],
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 8): [
      "1",
      "2",
      "3",
      "3",
      "3",
      "3",
    ],
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 3): [
      "123123"
    ],
  };

  List<String> _getListFromDay(DateTime date) {
    final mapKey = testEventList.keys.where((element) => isSameDay(element, date));
    if (mapKey.isNotEmpty) {
      return testEventList[mapKey.first] ?? [];
    }
    else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MediaQuery.of(context).orientation == Orientation.portrait
        ? _body()
        : SingleChildScrollView(
          child: _landscapeBody(),
        )
      )
    );
  }

  Widget _body() => Column(
    children: [
      ToggleButtons(
        borderWidth: 0,
        selectedColor: Colors.transparent,
        borderColor: Colors.transparent,
        fillColor: Colors.transparent,
        selectedBorderColor: Colors.transparent,
        disabledBorderColor: Colors.transparent,
        splashColor: Colors.transparent,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Calendar", 
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18, color: isSelected[0] ? Colors.black : Colors.grey.shade400
              )
            )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "List", 
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18, color: isSelected[1] ? Colors.black : Colors.grey.shade400
              )
            )
          ),
        ],
        isSelected: isSelected,
        onPressed: (int newIndex) {
          setState(() {
            var falseIndex = newIndex == 0 ? 1 : 0;
            if (!isSelected[newIndex]) {
              isSelected[newIndex] = true;
              isSelected[falseIndex] = false;
            }
          });
        },
      ),
      if (isSelected[0])
      Card(
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
          child: TableCalendar(
            firstDay: DateTime(2021, 5, 1),
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
            eventLoader: (day) => _getListFromDay(day),
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: isSameDay(_selectedDay, day) ? AppColors().primaryColor : AppColors().bgAccent,
                        borderRadius: BorderRadius.circular(4)
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
                fontWeight: FontWeight.bold
              ),
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: AppColors().bgAccent,
                borderRadius: BorderRadius.circular(6),
              ),
              formatButtonTextStyle: const TextStyle(
                color: Colors.white,
              ),
              leftChevronIcon: Icon(Icons.keyboard_arrow_left_rounded, color: AppColors().bgAccent),
              rightChevronIcon: Icon(Icons.keyboard_arrow_right_rounded, color: AppColors().bgAccent)
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              weekendStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
        ),
      ),
      Expanded(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              ListView.separated(
                itemBuilder: (ctx, index) {
                  if (index == _getListFromDay(_selectedDay).length) {
                    return const SizedBox(height: 75);
                  }
                  return ListTile(
                    title: Text( _getListFromDay(_selectedDay)[index]),
                  );
                },
                separatorBuilder: (_, __) => const Divider(),
                itemCount: _getListFromDay(_selectedDay).length + 1,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Expanded(
                      flex: 10,
                      child: AddElevatedButton("Add Transaction", () {
                        
                      }),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: Platform.isIOS || Platform.isMacOS
                        ? CupertinoButton.filled(
                          child: const Icon(Icons.filter_alt_rounded, color: Colors.white),
                          onPressed: () {

                          },
                          padding: const EdgeInsets.all(12)
                        )
                        : ElevatedButton(
                          onPressed: () {

                          },
                          child: Icon(Icons.filter_alt_rounded),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                            ),
                          ),
                        ),
                      )
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
    ],
  );

  Widget _landscapeBody() {
    //TODO: Implement
    return Container();
  }
}
