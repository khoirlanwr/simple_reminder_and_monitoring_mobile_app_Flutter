import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// class model for data alarm saved in sqlite
class DataPersistanceSqlite {
  int _id;
  String _firestoreId;
  String _title;
  String _desc;
  String _time;

  DataPersistanceSqlite(this._firestoreId, this._title, this._desc, this._time);

  DataPersistanceSqlite.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._firestoreId = map['firestoreId'];
    this._title = map['title'];
    this._desc = map['desc'];
    this._time = map['time'];
  }

  // getter
  int get id => _id;
  String get firestoreId => _firestoreId;
  String get title => _title;
  String get desc => _desc;
  String get time => _time;

  set title(String value) {
    _title = value;
  }

  set desc(String value) {
    _desc = value;
  }

  set time(String value) {
    _time = value;
  }

  set firestoreId(String value) {
    _firestoreId = value;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['firestoreId'] = firestoreId;
    map['title'] = title;
    map['desc'] = desc;
    map['time'] = time;

    return map;
  }
}

// class model for data sensors and set ntu variable
// class DataSensorsSQLite {}

// handle all operation with sqlite
class AccessBlocPersistDB {
  void _createDB(Database db, int version) async {
    await db.execute('''
        CREATE TABLE timerTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          firestoreId TEXT,
          title TEXT,
          desc TEXT,
          time TEXT
        )
    ''');
  }

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'timerDB.db';

    var timersDatabase = openDatabase(path, version: 1, onCreate: _createDB);
    return timersDatabase;
  }
}
