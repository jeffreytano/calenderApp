import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

enum ItemType { toDo, transaction, reminder }

class DateItem {
  final int id;
  String title;
  String? content;
  String? reminder;
  String? finished;

  DateItem(this.id, this.title, [this.content, this.reminder, this.finished]);
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

// final itemLists = LinkedHashMap<String, List<DateItem>>(
// )..addAll(itemSource);

final itemSource = {
  // date1: [
  //   DateItem(
  //     "Today's Event 1",
  //     ItemType.toDo,
  //     TimeOfDay(hour: 21, minute: 30),
  //     TimeOfDay(hour: 22, minute: 30),
  //   ),
  //   DateItem("Today's Event 2", ItemType.toDo, TimeOfDay(hour: 23, minute: 30)),
  //   DateItem("Today's Event 3", ItemType.transaction),
  //   DateItem("Today's Event 4", ItemType.transaction),
  //   DateItem("Today's Event 5", ItemType.transaction),
  // ],
  // date2: [DateItem("Today's Event 1", ItemType.transaction)],
};

// final date1 = DateTime.utc(2025, 5, 14);
// final date2 = DateTime.utc(2025, 5, 16);
