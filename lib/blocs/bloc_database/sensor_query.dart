import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class SensorNTUQuery extends ChangeNotifier {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  StreamSubscription<Event> _onNewDataAdded;

  int _dataNTU = 0;

  int get dataNTU => _dataNTU;

  // create

  // read
  Future<int> getLatestDataSensorNTU() async {
    int result = -1;
    await _database
        .reference()
        .child('sensors')
        .child('sensor_ntu')
        .orderByChild('id')
        .limitToLast(1)
        .once()
        .then((querySnapshot) {
      print('[getting latest data]');
      print(querySnapshot.value);

      Map<dynamic, dynamic> values = querySnapshot.value;

      values.forEach((key, value) {
        // print(value['id']);
        // print(value['data']);
        result = value['data'];
        _dataNTU = value['data'];
      });
    });

    notifyListeners();
    return result;
  }

  void initialStreamSubscription() {
    _onNewDataAdded = FirebaseDatabase.instance
        .reference()
        .child('sensors')
        .child('sensor_ntu')
        .onChildAdded
        .listen((event) {
      print('new event on data NTU catched ! : ');
      print(event.snapshot.value);
    });
  }

  // update
  // delete
}

SensorNTUQuery sensorNTUQuery = SensorNTUQuery();

class SensorPakanIkanQuery extends ChangeNotifier {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  StreamSubscription<Event> _onNewDataAdded;

  int _dataPakanIkan = 0;

  int get dataPakanIkan => _dataPakanIkan;

  // create
  // read
  Future<int> getLatestDataSensor() async {
    int result = -1;
    await _database
        .reference()
        .child('sensors')
        .child('sensor_pakan_ikan')
        .orderByChild('id')
        .limitToLast(1)
        .once()
        .then((dataSnapshot) {
      Map<dynamic, dynamic> values = dataSnapshot.value;
      values.forEach((key, value) {
        print(value['data']);
        result = value['data'];

        _dataPakanIkan = result;
      });
    });

    notifyListeners();
    return result;
  }

  // update
  // delete

  void initialSubscription() {
    _onNewDataAdded = FirebaseDatabase.instance
        .reference()
        .child('sensors')
        .child('sensor_pakan_ikan')
        .onChildAdded
        .listen((event) {
      print('New data added on sensor pakan ikan');
      print(event.snapshot.value);
    });
  }
}

SensorPakanIkanQuery sensorPakanIkanQuery = SensorPakanIkanQuery();
