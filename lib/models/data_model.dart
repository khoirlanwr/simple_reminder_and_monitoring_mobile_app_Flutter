import 'package:cloud_firestore/cloud_firestore.dart';

class DataModel {
  String docId;
  String title;
  String description;
  String time;

  DataModel({this.docId, this.time, this.title, this.description});
}

class NTUDataModel {
  String docId;
  double thresholdNtu;
  Timestamp ts;

  NTUDataModel({this.docId, this.thresholdNtu, this.ts});
}

class DataSensorModel {
  String docId;
  double sensorNTU;
  double sensorTBD;

  DataSensorModel({this.docId, this.sensorNTU, this.sensorTBD});
}

class DataModelSensorTBD {
  String docId;
  double dataTbd;

  DataModelSensorTBD({this.docId, this.dataTbd});
}
