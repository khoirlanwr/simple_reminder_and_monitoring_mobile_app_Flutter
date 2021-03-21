import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:todo_getx/blocs/bloc_database/threshold_ntu.dart';
import 'package:todo_getx/blocs/bloc_notification.dart';

class FirebaseEventListener {
  StreamSubscription<Event> _onNewDataNTUAdded;
  StreamSubscription<Event> _onNewDataPakanIkanAdded;

  StreamSubscription<Event> _onDataNTUChanged;
  StreamSubscription<Event> _onDataPakanIkanChanged;

  void initialSubscriberDataNTU() async {
    _onNewDataNTUAdded = FirebaseDatabase.instance
        .reference()
        .child('sensors')
        .child('sensor_ntu')
        .onChildAdded
        .listen(onDataNTUAddedAndChanged);

    _onDataNTUChanged = FirebaseDatabase.instance
        .reference()
        .child('sensors')
        .child('sensor_ntu')
        .onChildChanged
        .listen(onDataNTUAddedAndChanged);
  }

  onDataNTUAddedAndChanged(Event event) async {
    int ntuByUser = await thresholdNTU.getDataThresholdNTU();
    print('ntuByUser');
    print(ntuByUser);

    var data = event.snapshot.value['data'];
    if (ntuByUser < data) {
      // print('Data NTU > NTU by User');
      String isiReminder = "Data NTU [$data] > set NTU [$ntuByUser]";
      blocNotificationInstance.showNotification(isiReminder);
    }
  }

  void initialSubscriberDataPakanIkan() {
    _onNewDataPakanIkanAdded = FirebaseDatabase.instance
        .reference()
        .child('sensors')
        .child('sensor_pakan_ikan')
        .onChildAdded
        .listen((event) {
      print(event.snapshot.value);
      var doc = event.snapshot.value;
      if (doc['data'] == 0) {
        blocNotificationInstance.showNotification('Pakan Ikan Habis');
      }
    });

    _onDataPakanIkanChanged = FirebaseDatabase.instance
        .reference()
        .child('sensors')
        .child('sensor_pakan_ikan')
        .onChildChanged
        .listen((event) {
      var doc = event.snapshot.value;
      if (doc['data'] == 0) {
        blocNotificationInstance.showNotification('Pakan Ikan Habis');
      }
    });
  }
}

FirebaseEventListener firebaseEventListener = new FirebaseEventListener();
