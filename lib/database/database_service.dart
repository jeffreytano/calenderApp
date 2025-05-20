import 'dart:collection';

import 'package:calender_tool/utils.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _taskTableName = "dateItem";
  final String _taskIdColumnName = "id";
  final String _taskDateColumnName = "date";
  final String _taskMonthColumnName = "month";
  final String _taskDayColumnName = "day";
  final String _taskTitleColumnName = "title";
  final String _taskContentColumnName = "content";
  final String _taskReminderColumnName = "reminder";
  final String _taskFinishedColumnName = "finished";

  void createTable(Database db) {
    // db.execute('''
    //       CREATE TABLE $_taskTableName(
    //       $_taskIdColumnName INTEGER PRIMARY KEY,
    //       $_taskDateColumnName TEXT NOT NULL,
    //       $_taskTitleColumnName TEXT NOT NULL,
    //       $_taskContentColumnName TEXT,
    //       $_taskReminderColumnName INTEGER,
    //       $_taskFinishedColumnName INTEGER
    //       )
    //       ''');
    db.execute('''
          CREATE TABLE $_taskTableName(
          $_taskIdColumnName INTEGER PRIMARY KEY, 
          $_taskMonthColumnName TEXT NOT NULL, 
          $_taskDayColumnName TEXT NOT NULL, 
          $_taskTitleColumnName TEXT NOT NULL, 
          $_taskContentColumnName TEXT, 
          $_taskReminderColumnName INTEGER, 
          $_taskFinishedColumnName INTEGER
          )
          ''');
  }

  DatabaseService._constructor() {
    final today = DateTime.now();
    addItem(today, 'First Title', 'First Content', false, true);
  }

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await getDatabase();
      return _db!;
    }
  }

  Future<Database> getDatabase() async {
    final databaseRootPath = await getDatabasesPath();
    final databasePath = join(databaseRootPath, "master_database.db");
    final database = await openDatabase(
      version: 1,
      databasePath,
      onCreate: (db, version) {
        createTable(db);
        print('Created table $_taskTableName');
      },
    );
    return database;
  }

  void addItem(
    DateTime date,
    String title, [
    String? content,
    bool? reminder,
    bool? finished,
  ]) async {
    final month = DateFormat.yM().format(date);
    print(month);
    final day = DateFormat.d().format(date);
    print(day);
    final formattedDate = DateFormat.yMd().format(date);
    final db = await database;
    await db.insert(_taskTableName, {
      _taskMonthColumnName: month.toString(),
      _taskDayColumnName: day.toString(),
      _taskTitleColumnName: title,
      _taskContentColumnName: content,
      _taskReminderColumnName: reminder.toString(),
      _taskFinishedColumnName: finished.toString(),
    });
  }

  // Future<ItemListType> getMonthItem(DateTime day) async {
  //   final month = DateFormat.yM().format(day);
  //   print(month);
  //   final formattedDate = DateFormat.yMd().format(day);
  //   final db = await database;
  //   // final data = await db.query(
  //   //   _taskTableName,
  //   //   where: '$_taskMonthColumnName = ?',
  //   //   whereArgs: [month],
  //   // );

  //   final data = await db.rawQuery(
  //     'SELECT * FROM $_taskTableName WHERE $_taskMonthColumnName = "$month"',
  //   );

  //   return convertQueryResult(data);
  // }

  Future<LinkedHashMap<String, int>> getMonthItemCount(DateTime day) async {
    final month = DateFormat.yM().format(day);
    final formattedDate = DateFormat.yMd().format(day);
    final db = await database;

    final data = await db.rawQuery(
      'SELECT $_taskDayColumnName, COUNT(*) AS count FROM $_taskTableName WHERE $_taskMonthColumnName = "$month" GROUP BY $_taskDayColumnName',
    );

    print(data);

    return convertQueryResult(data);
  }

  LinkedHashMap<String, int> convertQueryResult(
    List<Map<String, Object?>> data,
  ) {
    print('convertQueryResult');
    print(data);
    LinkedHashMap<String, int> retData = LinkedHashMap<String, int>();

    for (var item in data) {
      final String dayText = item['day'] as String;
      retData[dayText] = item['count'] as int;
    }

    return retData;
  }

  void clearTable() async {
    final db = await database;
    db.execute("DELETE FROM $_taskTableName");
  }

  void recreateTable() async {
    final db = await database;
    db.execute("DROP TABLE IF EXISTS $_taskTableName");
    createTable(db);
  }

  void viewAllRows() async {
    final db = await database;
    final data = await db.query(_taskTableName);
    print(data);
  }
}
