// Description:
// Handle data to interface with Realtime Database

// Realtime Database!
// Realtime Database!

// Realtime Database!
// Realtime Database!

// Realtime Database!
// Realtime Database!

// Realtime Database!
// Realtime Database!

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimerDatabase extends ChangeNotifier {
  // create new data
  void createDataTimer(
      int sqliteID, String title, String description, String time) async {
    await FirebaseDatabase.instance
        .reference()
        .child('timers')
        .child('records-' + sqliteID.toString())
        .set({
      'title': title,
      'idsqlite': sqliteID,
      'description': description,
      'time': time,
    }).then((value) => null);
  }

  // get data
  void readDataTimer() async {
    print('-----------------> readDataTimer');

    await FirebaseDatabase.instance
        .reference()
        .child('timers')
        .orderByKey()
        .once()
        .then((querySnapshot) {
      print(querySnapshot.value);
    });
  }

  // delete data
  void deleteDataTimer(int sqliteID) {
    String _childPath = "records-" + sqliteID.toString();
    FirebaseDatabase.instance
        .reference()
        .child('timers')
        .child(_childPath)
        .remove();
  }

  // update data
  void updateDataTimer(int sqliteID, String title, String desc, String time) {
    String _childPath = "records-" + sqliteID.toString();
    FirebaseDatabase.instance
        .reference()
        .child('timers')
        .child(_childPath)
        .update({'title': title, 'description': desc, 'time': time});

    // thresholdNTU.updateDataThresholdNTU(300);
  }
}

TimerDatabase timerDatabase = new TimerDatabase();
