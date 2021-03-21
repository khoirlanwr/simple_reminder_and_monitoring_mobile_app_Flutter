import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class TestProvider extends ChangeNotifier {
  int _data = 0;

  int get data => _data;

  void increment(int dataAwal) async {
    // add data to firebase
    await FirebaseDatabase.instance
        .reference()
        .child('threshold_ntu')
        .set({"set_ntu": dataAwal}).then((value) {
      _data = dataAwal;

      notifyListeners();
    });
  }
}
