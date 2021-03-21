// HANDLE DATA INTERFACED WITH FIRESTORE
// COLLECTIONS: timers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_getx/blocs/bloc_database/timer_database.dart';
import 'package:todo_getx/blocs/bloc_persist.dart';
import 'package:todo_getx/models/data_model.dart';

import 'package:random_string/random_string.dart';

import 'package:todo_getx/models/persist_model.dart';

class BlocTimer extends ChangeNotifier {
  // create collection relate to database
  CollectionReference timers = FirebaseFirestore.instance.collection('timers');

  // add data
  Future<void> addTimer(String title, String description, TimeOfDay time) {
    String _preHourTime = "";
    String _preMinuteTime = "";

    if (time.hour < 10) _preHourTime = "0";
    if (time.minute < 10) _preMinuteTime = "0";

    // generate random string for document id
    String _randGeneratedId = randomAlphaNumeric(11);

    String timer = _preHourTime +
        time.hour.toString() +
        ":" +
        _preMinuteTime +
        time.minute.toString();

    return timers
        .doc(_randGeneratedId)
        .set({'title': title, 'description': description, 'time': timer}).then(
            (value) {
      DataPersistanceSqlite dataPersistanceSqlite = new DataPersistanceSqlite(
          _randGeneratedId, title, description, timer);

      // *** IMPORTANT ****
      // PERSIST DATA TO SQLITE
      crudSQLite.insert(dataPersistanceSqlite);
      print('data added successfull');

      // notity to alls
      notifyListeners();
    }).catchError((error) => print('error added timer: $error'));
  }

  // get all data
  Future<List<DataModel>> getTimers() async {
    List<DataModel> dataQuery = List<DataModel>();

    await timers.get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        var docId = result.id;
        var doc = result.data();

        DataModel dataModel = new DataModel(
            docId: docId,
            time: doc['time'],
            title: doc['title'],
            description: doc['description']);

        dataQuery.add(dataModel);
      });
    });

    print(dataQuery.length);
    return dataQuery;
  }

  // get data by id
  Future<DataModel> getTimerById(String docId) async {
    DataModel resultModel = DataModel();

    await timers.doc(docId).get().then((value) {
      var doc = value.data();

      resultModel.docId = docId;
      resultModel.time = doc['time'];
      resultModel.title = doc['title'];
      resultModel.description = doc['description'];
    });

    // debug only
    // 18:19, 18:25, 05:49
    // crudSQLite.delete("18:25");
    crudSQLite.getTimerDataList();
    return resultModel;
  }

  // static function to convert format time
  static DateTime parseData(String time) {
    String date = "2021-02-20 ";
    String completeTime = date + time + ":00Z";

    var createdDate = DateTime.parse(completeTime);
    return createdDate;
  }

  // delete document by id
  Future<void> deleteTimerbyId(String docId) async {
    await timers.doc(docId).delete().then((value) {
      // *** IMPORTANT ****
      // *** PERSIST DATA TO SQLITE
      // crudSQLite.delete(docId);

      print('doc with id $docId deleted');
    }).catchError(
        (error) => print('Failure to delete data with doc id: $docId'));
    notifyListeners();
  }

  // update data document by id
  Future<void> updateTimerbyId(
      String docId, String title, String description, TimeOfDay time) async {
    // String operation
    String _preHourTime = "";
    String _preMinuteTime = "";

    if (time.hour < 10) _preHourTime = "0";
    if (time.minute < 10) _preMinuteTime = "0";

    String timer = _preHourTime +
        time.hour.toString() +
        ":" +
        _preMinuteTime +
        time.minute.toString();

    await timers.doc(docId).update({
      'title': title,
      'description': description,
      'time': timer,
    }).then((value) {
      // *** IMPORTANT ***
      // *** PERSIST DATA TO SQLITE ***
      DataPersistanceSqlite dataPersistanceSqlite =
          new DataPersistanceSqlite(docId, title, description, timer);
      crudSQLite.update(dataPersistanceSqlite);
      print('doc with id $docId updated');
    }).catchError((error) => print('error $error update data'));

    notifyListeners();
  }

  static Future<List<String>> getAllStoredTimersOnly() async {
    List<String> _allStoredTimersFromFirestore = [];

    // get data from firestore
    await FirebaseFirestore.instance
        .collection('timers')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        var doc = element.data();
        _allStoredTimersFromFirestore.add(doc['time']);
      });
    });

    // **** IMPORTANT ****
    // **** PERSIST DATA SQLITE ****
    crudSQLite.getTimerDataList();

    print(_allStoredTimersFromFirestore);
    return _allStoredTimersFromFirestore;
  }
}
