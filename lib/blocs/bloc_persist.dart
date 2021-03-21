// HANDLE DATA INTERFACED WITH SQLITE
// SQLITE!
// SQLITE!

// SQLITE!
// SQLITE!

// SQLITE!
// SQLITE!

// SQLITE!
// SQLITE!

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:todo_getx/blocs/bloc_database/timer_database.dart';
import 'package:todo_getx/models/persist_model.dart';

class CRUD extends ChangeNotifier {
  static const timerTable = 'timerTable';
  static const id = 'id';
  static const firestoreId = 'firestoreId';
  static const title = 'title';
  static const desc = 'desc';
  static const time = 'time';

  AccessBlocPersistDB dbHelper = new AccessBlocPersistDB();

  // insert ke tabel yang ada di dalam database
  Future<int> insert(DataPersistanceSqlite data) async {
    Database db = await dbHelper.initDb();
    final sql = '''INSERT INTO ${CRUD.timerTable}
    (
      ${CRUD.firestoreId},
      ${CRUD.title},
      ${CRUD.desc},
      ${CRUD.time}
    )
    VALUES(?,?,?,?)''';

    List<dynamic> params = [data.firestoreId, data.title, data.desc, data.time];
    final result = await db.rawInsert(sql, params);
    notifyListeners();

    print(result);

    // IMPORTANT SECTION
    // This section will save data to realtime database
    timerDatabase.createDataTimer(result, data.title, data.desc, data.time);

    return result;
  }

  // update data
  Future<int> update(DataPersistanceSqlite data) async {
    Database db = await dbHelper.initDb();

    final sql = '''UPDATE ${CRUD.timerTable}
    SET ${CRUD.title} = ?, ${CRUD.desc} = ?, ${CRUD.time} = ?
    WHERE ${CRUD.id} = ?''';

    List<dynamic> params = [data.title, data.desc, data.time, data.id];
    final result = await db.rawUpdate(sql, params);

    notifyListeners();

    // IMPORTANT SECTION: update data in realtime database also on this record
    timerDatabase.updateDataTimer(data.id, data.title, data.desc, data.time);

    return result;
  }

  // delete data by id
  Future<int> delete(int id) async {
    Database db = await dbHelper.initDb();
    int count =
        await db.delete(CRUD.timerTable, where: 'id=?', whereArgs: [id]);

    notifyListeners();

    // IMPORTANT SECTIONS: delete same record in realtime database also
    timerDatabase.deleteDataTimer(id);

    return count;
  }

  Future<List<DataPersistanceSqlite>> getTimerDataList() async {
    Database db = await dbHelper.initDb();
    List<Map<String, dynamic>> mapList =
        await db.query(CRUD.timerTable, orderBy: 'title');

    int lengthData = mapList.length;

    List<DataPersistanceSqlite> timerDataLists = List<DataPersistanceSqlite>();
    for (int i = 0; i < lengthData; i++) {
      timerDataLists.add(DataPersistanceSqlite.fromMap(mapList[i]));
      // print(timerDataLists[i].time);
    }

    return timerDataLists;
  }

  // static function to convert format time
  static DateTime parseData(String time) {
    String date = "2021-02-20 ";
    String completeTime = date + time + ":00Z";

    var createdDate = DateTime.parse(completeTime);
    return createdDate;
  }
}

CRUD crudSQLite = new CRUD();
