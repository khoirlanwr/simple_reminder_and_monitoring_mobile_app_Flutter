import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_getx/services/event_listener.dart';

import 'counter_service.dart';

void backgroundMain() {
  WidgetsFlutterBinding.ensureInitialized();

  // initial firebase
  Firebase.initializeApp().whenComplete(() {
    print('[INITIAL FIREBASE COMPLETED.]');
  });

  // initial streamsubccription
  firebaseEventListener.initialSubscriberDataNTU();
  firebaseEventListener.initialSubscriberDataPakanIkan();

  CounterService.instance().startCounting();
}
