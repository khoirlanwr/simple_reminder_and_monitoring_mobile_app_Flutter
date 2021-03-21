import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class ServoControl extends ChangeNotifier {
  final String _childPath = "servo_control";
  final String _recordName = "set_servo";

  // this variable holds the information servo
  int _dataServo = 0;

  // getter
  int get dataServo => _dataServo;

  // CREATE
  void createData(int servoValue) async {
    await FirebaseDatabase.instance
        .reference()
        .child(_childPath)
        .set({_recordName: servoValue}).then((value) {
      print('data servo control set successfully');
      _dataServo = servoValue;
      notifyListeners();
    });
  }

  // READ
  Future<int> getLatestData() async {
    int result = -1;

    await FirebaseDatabase.instance
        .reference()
        .child(_childPath)
        .once()
        .then((querySnapshot) {
      _dataServo = querySnapshot.value['set_servo'];
      notifyListeners();

      result = _dataServo;
    });

    return result;
  }
}
