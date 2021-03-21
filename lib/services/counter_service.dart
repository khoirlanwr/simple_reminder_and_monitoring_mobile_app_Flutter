import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todo_getx/blocs/bloc_database/sensor_query.dart';
import 'package:todo_getx/blocs/bloc_database/threshold_ntu.dart';

import 'package:todo_getx/blocs/bloc_notification.dart';
import 'package:todo_getx/models/persist_model.dart';

import 'package:todo_getx/services/counter.dart';

import 'package:todo_getx/blocs/bloc_persist.dart';

class CounterService {
  factory CounterService.instance() => _instance;

  CounterService._internal();

  static final _instance = CounterService._internal();

  final _counter = Counter();

  ValueListenable<int> get count => _counter.count;

  void startCounting() {
    Stream.periodic(Duration(seconds: 5)).listen((_) async {
      // _counter.increment();
      // print('Counter Incremented: ${_counter.count.value}');

      // let your function here
      // customTestFunction();

      // Kondisi 1 sesuai reminder
      handleTimeReminderNotification();

      // kondisi 2: polling data sensor NTU
      handleSensorNTUNotification();

      // Kondisi 3: lihat status data sensor pakan ikan
      handleSensorPakanIkanNotification();
    });
  }


  void handleTimeReminderNotification() async {
    TimeOfDay _timeNow = TimeOfDay.now();

    String _now = preProcessGetTime(_timeNow);
    print('[TIME NOW]: ' + _now);

    List<DataPersistanceSqlite> timerList = await crudSQLite.getTimerDataList();
    for (int i = 0; i < timerList.length; i++) {
      print('---------------------> [LOCAL]');
      print(timerList[i].time + '|' + timerList[i].id.toString());

      if (_now == timerList[i].time) {
        // firedNotification();
        String titleReminder = timerList[i].title;

        print('--------------------> kondisi 1 masuk');
        blocNotificationInstance.showNotification('$titleReminder [$_now]');
      }
    }
  }

  void handleSensorNTUNotification() async {
    // compare sensor ntu resulted from firebase with ntu which is set by user
    Firebase.initializeApp().whenComplete(() {
      print("------------------------> firebase initial completed");
    });

    int ntuByUser = await thresholdNTU.getDataThresholdNTU();
    print('NTU BY USER: ');
    print(ntuByUser);

    int ntuNow = await sensorNTUQuery.getLatestDataSensorNTU();
    print('NTU now');
    print(ntuNow);

    if (ntuNow > ntuByUser) {
      // blocNotificationInstance
      //     .showNotification('Set NTU[$ntuByUser] > Data NTU[$ntuNow]');
      blocNotificationInstance
          .showNotification('Air terdeteksi keruh! Saatnya penggantian air');
    }
  }

  void handleSensorPakanIkanNotification() async {
    Firebase.initializeApp().whenComplete(() {
      print("------------------------> firebase initial completed");
    });

    int statusPakanIkan = await sensorPakanIkanQuery.getLatestDataSensor();
    print('Status Pakan Ikan');
    print(statusPakanIkan);

    if (statusPakanIkan == 0) {
      blocNotificationInstance.showNotification('Pakan Terdeteksi Habis!');
    }
  }

  String preProcessGetTime(TimeOfDay time) {
    String _preHourTime = "";
    String _preMinuteTime = "";

    if (time.hour < 10) _preHourTime = "0";
    if (time.minute < 10) _preMinuteTime = "0";

    return _preHourTime +
        time.hour.toString() +
        ":" +
        _preMinuteTime +
        time.minute.toString();
  }

  void customTestFunction() async {
    int ntuByUser = await thresholdNTU.getDataThresholdNTU();
    print('NTU BY USER: ');
    print(ntuByUser);

    int ntuNow = await sensorNTUQuery.getLatestDataSensorNTU();
    print('NTU now');
    print(ntuNow);

    int statusPakanIkan = await sensorPakanIkanQuery.getLatestDataSensor();
    print('status Pakan Ikan');
    print(statusPakanIkan);

    // if (ntuNow > ntuByUser) {
    //   firedNotification();
    // }
  }
}
