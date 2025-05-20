import 'dart:collection';

import 'package:calender_tool/data/constants.dart';
import 'package:calender_tool/database/database_service.dart';
import 'package:calender_tool/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class TableCalenderWidget extends StatefulWidget {
  const TableCalenderWidget({super.key});

  @override
  State<TableCalenderWidget> createState() => _TableCalenderWidgetState();
}

class _TableCalenderWidgetState extends State<TableCalenderWidget> {
  late final ValueNotifier<List<DateItem>> _selectedDateItems;
  late final ValueNotifier<LinkedHashMap<String, int>> _currentMonthItemsCount;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _selectedItem = -1;
  final database = DatabaseService.instance;
  // final ValueNotifier<ItemListType> _currentMonthItems = await database.getMonthItem(_selectedDay ? DateTime.now());

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _currentMonthItemsCount = ValueNotifier(LinkedHashMap<String, int>());
    _selectedDateItems = ValueNotifier(_getItemsForDay(_selectedDay!));
    fetchMonthData(_selectedDay);
  }

  @override
  void dispose() {
    // _selectedDateItems.dispose();
    super.dispose();
  }

  Future<void> fetchMonthData(day) async {
    final data = await database.getMonthItemCount(day);
    print(data);
    _currentMonthItemsCount.value = data;
  }

  List<DateItem> _getItemsForDay(DateTime day) {
    final String dayText = DateFormat.d().format(day);
    return [DateItem(0, 'title')];
    // need to change the return
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedItem = -1;
      });

      _selectedDateItems.value = _getItemsForDay(selectedDay);
    }
  }

  void _onMonthChanged(DateTime day) async {
    print('triggered onMonthChanged');
    fetchMonthData(day);
  }

  void _onItemSelected(int index) {
    print(index);
    setState(() {
      _selectedItem = index;
    });
  }

  Widget itemBuilder(DateItem item) {
    final title = item.title;
    return Text(title);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          focusedDay: _focusedDay,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
          eventLoader: _getItemsForDay,
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: CalendarStyle(
            weekendTextStyle: TextStyle(color: PresetColor.weekendColor),
            selectedDecoration: BoxDecoration(
              color: PresetColor.selectedColor,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: PresetColor.todayColor,
              shape: BoxShape.circle,
            ),
          ),
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TextStyle(color: PresetColor.weekdayTitleColor),
            weekendStyle: TextStyle(color: PresetColor.weekendTitleColor),
          ),

          firstDay: DateTime(2025, 1, 1, 00, 00),
          lastDay: DateTime(2030, 12, 31, 23, 59),
          onDaySelected: _onDaySelected,
          onPageChanged: _onMonthChanged,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              if (events.isNotEmpty) {
                return Positioned(
                  right: 1,
                  bottom: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red, // Customize the background color
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ), // Make it rounded
                    ),
                    padding: EdgeInsets.all(2),
                    constraints: BoxConstraints(minWidth: 20, minHeight: 20),
                    child: Center(
                      child: Text(
                        '${events.length}', // Display the event count
                        style: TextStyle(
                          color: Colors.white, // Customize the text color
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
        const SizedBox(height: 8.0),
        // Expanded(
        //   child: ValueListenableBuilder<List<DateItem>>(
        //     valueListenable: _selectedDateItems,
        //     builder: (context, value, child) {
        //       return ListView.builder(
        //         itemCount: value.length,
        //         itemBuilder: (context, index) {
        //           return Container(
        //             margin: const EdgeInsets.symmetric(
        //               horizontal: 12.0,
        //               vertical: 4.0,
        //             ),
        //             decoration: BoxDecoration(
        //               border: Border.all(
        //                 color:
        //                     _selectedItem == index ? Colors.red : Colors.black,
        //               ),
        //               color:
        //                   _selectedItem == index
        //                       ? Colors.purple
        //                       : Colors.lightBlue,
        //               borderRadius: BorderRadius.circular(12.0),
        //             ),
        //             child: ListTile(
        //               onTap: () => _onItemSelected(index),
        //               title: Text(value[index].title),
        //             ),
        //           );
        //         },
        //       );
        //     },
        //   ),
        // ),
        Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
                child: Center(child: Text('Button1')),
              ),
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
                child: Center(child: Text('Button2')),
              ),
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.red,
                ),
                child: Center(
                  child: TextButton(
                    onPressed:
                        () => DatabaseService.instance.addItem(
                          DateTime.now(),
                          'title',
                          'content',
                        ),
                    child: Text('Add Default Item'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
