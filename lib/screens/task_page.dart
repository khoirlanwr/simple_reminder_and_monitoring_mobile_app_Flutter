import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:todo_getx/blocs/bloc_persist.dart';
import 'package:todo_getx/models/persist_model.dart';
import 'package:todo_getx/widgets/size_config.dart';

class TaskPage extends StatefulWidget {
  final DataPersistanceSqlite recordDataModel;

  TaskPage({Key key, @required this.recordDataModel}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  String _hour, _minute, _time;
  String _setTime;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  TextEditingController _timeController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ':' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2021, 02, 20, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
    }
  }

  void updateDataToDatabase(BuildContext context, String title,
      String description, TimeOfDay time, int id) {
    String _preHourTime = "";
    String _preMinuteTime = "";

    if (selectedTime.hour < 10) _preHourTime = "0";
    if (selectedTime.minute < 10) _preMinuteTime = "0";

    String timer = _preHourTime +
        selectedTime.hour.toString() +
        ":" +
        _preMinuteTime +
        selectedTime.minute.toString();

    DataPersistanceSqlite dataPersistanceSqlite = widget.recordDataModel;

    dataPersistanceSqlite.time = timer;
    dataPersistanceSqlite.title = title;
    dataPersistanceSqlite.desc = description;

    Provider.of<CRUD>(context, listen: false).update(dataPersistanceSqlite);
  }

  void deleteDataFromDB(BuildContext context, int id) {
    Provider.of<CRUD>(context, listen: false).delete(widget.recordDataModel.id);
  }

  void addDataToDatabase(BuildContext context, String title, String description,
      TimeOfDay selectedTime) {
    String _firestoreID = randomAlphaNumeric(11);

    String _preHourTime = "";
    String _preMinuteTime = "";

    if (selectedTime.hour < 10) _preHourTime = "0";
    if (selectedTime.minute < 10) _preMinuteTime = "0";

    String timer = _preHourTime +
        selectedTime.hour.toString() +
        ":" +
        _preMinuteTime +
        selectedTime.minute.toString();

    DataPersistanceSqlite dataPersistanceSqlite =
        new DataPersistanceSqlite(_firestoreID, title, description, timer);

    Provider.of<CRUD>(context, listen: false).insert(dataPersistanceSqlite);
  }

  @override
  void initState() {
    _timeController.text = formatDate(
        DateTime(2021, 02, 20, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();

    if (widget.recordDataModel != null) {
      _titleController.text = widget.recordDataModel.title;
      _descController.text = widget.recordDataModel.desc;

      // todo: konvert time controller text ke timeof day selected time
      // agar bisa diupdate
      _timeController.text = widget.recordDataModel.time;
      var timeFromDB = CRUD.parseData(widget.recordDataModel.time);
      selectedTime =
          TimeOfDay(hour: timeFromDB.hour, minute: timeFromDB.minute);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var titleField = Row(
      children: [
        Padding(
            padding:
                EdgeInsets.only(right: SizeConfig.safeBlockHorizontal * 4.0),
            child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image(
                    image: AssetImage('assets/images/back_arrow_icon.png')))),
        Expanded(
            child: TextField(
          controller: _titleController,
          decoration: InputDecoration(
              hintText: 'Judul Reminder', border: InputBorder.none),
          style: TextStyle(
              fontSize: SizeConfig.safeBlockHorizontal * 7.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF211551)),
        ))
      ],
    );

    var descField = TextField(
      controller: _descController,
      style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 4.7),
      decoration: InputDecoration(
          hintText: 'Deskripsi Reminder',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
              horizontal: SizeConfig.safeBlockHorizontal * 1.7)),
    );

    var timeField = InkWell(
        onTap: () {
          _selectTime(context);
        },
        child: Container(
          margin:
              EdgeInsets.symmetric(vertical: SizeConfig.safeBlockVertical * 4),
          width: SizeConfig.safeBlockHorizontal * 46,
          height: SizeConfig.safeBlockVertical * 10,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius:
                  BorderRadius.circular(SizeConfig.safeBlockHorizontal * 2)),
          child: TextFormField(
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.safeBlockHorizontal * 8.0,
              ),
              textAlign: TextAlign.center,
              onSaved: (String val) {
                _setTime = val;
              },
              enabled: false,
              keyboardType: TextInputType.text,
              controller: _timeController,
              decoration: InputDecoration(
                disabledBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
              )),
        ));

    var saveButton = Positioned(
        bottom: SizeConfig.safeBlockVertical * 0.2,
        right: SizeConfig.safeBlockHorizontal * 0.2,
        child: GestureDetector(
          onTap: () {
            // act to save or update
            if (widget.recordDataModel == null) {
              // save data if there is no data model passed to this screen
              // then just save it to sqlite
              addDataToDatabase(context, _titleController.text,
                  _descController.text, selectedTime);
            } else {
              // otherwise update data

              updateDataToDatabase(
                  context,
                  _titleController.text,
                  _descController.text,
                  selectedTime,
                  widget.recordDataModel.id);
            }

            Navigator.pop(context);
          },
          child: Container(
            width: SizeConfig.safeBlockHorizontal * 15.0,
            height: SizeConfig.safeBlockVertical * 7.5,
            decoration: BoxDecoration(
                color: Color(0xFF7349FE),
                borderRadius:
                    BorderRadius.circular(SizeConfig.safeBlockHorizontal * 2)),
            child: Image(image: AssetImage('assets/images/check_icon.png')),
          ),
        ));

    var deleteButton = Positioned(
        left: SizeConfig.safeBlockHorizontal * 0.2,
        bottom: SizeConfig.safeBlockVertical * 0.2,
        child: GestureDetector(
          onTap: () {
            // delete data from
            deleteDataFromDB(context, widget.recordDataModel.id);
            Navigator.pop(context);
          },
          child: Container(
            child: Image(image: AssetImage('assets/images/delete_icon.png')),
            width: SizeConfig.safeBlockHorizontal * 15.0,
            height: SizeConfig.safeBlockVertical * 7.5,
            decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius:
                    BorderRadius.circular(SizeConfig.safeBlockHorizontal * 2)),
          ),
        ));

    return Scaffold(
      body: SafeArea(
          child: Container(
              color: Color(0xFFF6F6F6),
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.safeBlockVertical * 3.0,
                  horizontal: SizeConfig.safeBlockHorizontal * 6.0),
              child: Stack(
                children: [
                  Column(
                    children: [titleField, descField, timeField],
                  ),

                  // positioned saveButton
                  saveButton,
                  widget.recordDataModel != null
                      ? deleteButton
                      : Container(
                          width: 0,
                          height: 0,
                        )
                ],
              ))),
    );
  }
}
