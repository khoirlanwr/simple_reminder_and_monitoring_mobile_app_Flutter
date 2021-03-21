import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class ThresholdNTU extends ChangeNotifier {
  final String _childPath = "threshold_ntu";
  final String _recordName = "set_ntu";

  String dataNtu = "";

  int _dataThreshold = 0;

  int get dataThreshold => _dataThreshold;

  // create
  Future<String> createDataThresholdNTU(int thresholdNtu) async {
    String result = "-1";

    await FirebaseDatabase.instance
        .reference()
        .child(_childPath)
        .set({_recordName: thresholdNtu}).then((value) {
      print('data set ntu successfully created');
      _dataThreshold = thresholdNtu;
      notifyListeners();
    }).catchError((error) => print('error $error while create data set ntu'));

    // this.dataNtu = thresholdNtu.toString();
    // print(dataNtu);
    result = dataNtu;
    // notifyListeners();

    return result;
  }

  // read
  Future<int> getDataThresholdNTU() async {
    print('------------------->>>>>> getDataThresholdNTU');
    var data;
    await FirebaseDatabase.instance
        .reference()
        .child(_childPath)
        .once()
        .then((querySnapshot) {
      print(querySnapshot.value);
      data = querySnapshot.value;
    });

    print('[getDataThreshold]');
    print(data['set_ntu']);

    _dataThreshold = data['set_ntu'];
    notifyListeners();

    return data['set_ntu'];
  }

  // stream data
  Future<int> getDataStream() async {
    int res;
    FirebaseDatabase.instance
        .reference()
        .child(_childPath)
        .onChildChanged
        .listen((event) {
      res = event.snapshot.value;
      print('value of new _dataNTU: ' + res.toString());

      getDataThresholdNTU();
      this.dataNtu = res.toString();

      print('dataNTU: ' + dataNtu);
      notifyListeners();
    });

    return res;
  }

  // update
  void updateDataThresholdNTU(int thresholdSetNTU) async {
    await FirebaseDatabase.instance
        .reference()
        .child(_childPath)
        .update({_recordName: thresholdSetNTU}).then((value) {
      print('records ntu updated');
    }).catchError((onError) => print('error $onError while update data'));

    dataNtu = thresholdSetNTU.toString();
    notifyListeners();
  }

  // delete
  void deleteDataThresholdNTU() async {
    await FirebaseDatabase.instance
        .reference()
        .child(_childPath)
        .remove()
        .then((value) {
      print('records set ntu deleted');
    });

    notifyListeners();
  }
}

ThresholdNTU thresholdNTU = new ThresholdNTU();
