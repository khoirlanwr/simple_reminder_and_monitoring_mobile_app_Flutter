import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todo_getx/blocs/bloc_database/sensor_query.dart';
import 'package:todo_getx/blocs/bloc_database/servo_control.dart';

import 'package:todo_getx/blocs/bloc_database/threshold_ntu.dart';
import 'package:todo_getx/blocs/bloc_persist.dart';
import 'package:todo_getx/blocs/bloc_user.dart';

import 'package:todo_getx/models/persist_model.dart';

import 'package:todo_getx/screens/login_page.dart';
import 'package:todo_getx/screens/task_page.dart';

import 'package:todo_getx/widgets/sensor_widget.dart';
import 'package:todo_getx/widgets/size_config.dart';
import 'package:todo_getx/widgets/task_card.dart';

import 'package:rflutter_alert/rflutter_alert.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String resultRecordedLogin = "loading";
  TextEditingController _controllerSetNTU = TextEditingController();
  TextEditingController _controllerSetServo = TextEditingController();

  bool initialStateSetNTU = true;

  void checkRecordedLogin(BuildContext context) async {
    String result = await Provider.of<BlocUser>(context, listen: false)
        .getLoginRecordFromSF();

    setState(() {
      if (result != "getLoginRecordFromSF-success") {
        resultRecordedLogin = "getLoginRecordFromSF-failure";
      }

      resultRecordedLogin = result;
    });
  }

  void initialStateFirebaseDatabase() {
    Provider.of<ThresholdNTU>(context, listen: false).getDataThresholdNTU();
    Provider.of<ServoControl>(context, listen: false).getLatestData();

    Provider.of<SensorNTUQuery>(context, listen: false)
        .getLatestDataSensorNTU();
    Provider.of<SensorPakanIkanQuery>(context, listen: false)
        .getLatestDataSensor();
  }

  void signOutFromFirebase() async {
    await Provider.of<BlocUser>(context, listen: false).signOut();
    setState(() {
      resultRecordedLogin = "logged-out";
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (BuildContext context) => HomePage()));
    });
  }

  void showAlertSetServo(BuildContext context) {
    Alert(
        context: context,
        title: 'Set Servo',
        content: Padding(
          padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 1),
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: _controllerSetServo,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: SizeConfig.safeBlockHorizontal * 4.2,
                ),
              ),
              Divider(height: SizeConfig.safeBlockVertical * 0.5),
            ],
          ),
        ),
        buttons: [
          DialogButton(
              child: Text(
                'Set Nilai',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              onPressed: () {
                print(' ------------------>>> NTU SETTED');

                int varSetServo = int.parse(_controllerSetServo.text);

                Provider.of<ServoControl>(context, listen: false)
                    .createData(varSetServo);

                // Provider.of<ThresholdNTU>(context, listen: false)
                //     .createDataThresholdNTU(varSetNTU);

                Navigator.pop(context);
              })
        ]).show();
  }

  void showAlertSetNTU(BuildContext context) {
    Alert(
        context: context,
        title: 'Set NTU',
        content: Padding(
          padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 1),
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: _controllerSetNTU,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: SizeConfig.safeBlockHorizontal * 4.2,
                ),
              ),
              Divider(height: SizeConfig.safeBlockVertical * 0.5),
            ],
          ),
        ),
        buttons: [
          DialogButton(
              child: Text(
                'Set Nilai',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              onPressed: () {
                print(' ------------------>>> NTU SETTED');

                int varSetNTU = int.parse(_controllerSetNTU.text);

                Provider.of<ThresholdNTU>(context, listen: false)
                    .createDataThresholdNTU(varSetNTU);

                Navigator.pop(context);
              })
        ]).show();
  }

  // Stream Subscription for new data added
  StreamSubscription<Event> _onSensorNTUAddedSubscription;
  StreamSubscription<Event> _onSensorPakanIkanAddedSubscription;

  // Stream subscription for updated data
  StreamSubscription<Event> _onSensorNTUChangedSubscription;
  StreamSubscription<Event> _onSensorPakanIkanChangedSubscription;

  @override
  void initState() {
    // main function to check wether the recorded login was
    // saved or not in shared preferences
    checkRecordedLogin(context);

    //FOR SUBSCRIPTION AND LISTEN TO FIREBASE
    _onSensorNTUAddedSubscription = FirebaseDatabase.instance
        .reference()
        .child('sensors')
        .child('sensor_ntu')
        .onChildAdded
        .listen(onDataSensorNTUEntryAdded);

    _onSensorPakanIkanAddedSubscription = FirebaseDatabase.instance
        .reference()
        .child('sensors')
        .child('sensor_pakan_ikan')
        .onChildAdded
        .listen(onDataSensorPakanIkanEntryAdded);

    _onSensorPakanIkanChangedSubscription = FirebaseDatabase.instance
        .reference()
        .child('sensors')
        .child('sensor_pakan_ikan')
        .onChildChanged
        .listen((event) {
      Provider.of<SensorPakanIkanQuery>(context, listen: false)
          .getLatestDataSensor();
    });

    _onSensorNTUChangedSubscription = FirebaseDatabase.instance
        .reference()
        .child('sensors')
        .child('sensor_ntu')
        .onChildChanged
        .listen((event) {
      Provider.of<SensorNTUQuery>(context, listen: false)
          .getLatestDataSensorNTU();
    });

    initialStateFirebaseDatabase();
    super.initState();
  }

  @override
  void dispose() {
    _onSensorNTUAddedSubscription.cancel();
    _onSensorPakanIkanAddedSubscription.cancel();

    _onSensorNTUChangedSubscription.cancel();
    _onSensorPakanIkanChangedSubscription.cancel();

    super.dispose();
  }

  onDataSensorPakanIkanEntryAdded(Event event) {
    print('new event onDataSensorPakanIkanEntryAdded catched ! : ');
    print(event.snapshot.value);

    Provider.of<SensorPakanIkanQuery>(context, listen: false)
        .getLatestDataSensor();
  }

  onDataSensorNTUEntryAdded(Event event) {
    print('new event onDataSensorNTUEntryAdded catched ! : ');
    print(event.snapshot.value);

    Provider.of<SensorNTUQuery>(context, listen: false)
        .getLatestDataSensorNTU();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final newLogo = Container(
      child: Image(
        image: AssetImage('assets/images/Lambang-UM.png'),
        width: 80,
        height: 80,
      ),
      margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
    );

    final logo = Container(
      child: Image(image: AssetImage('assets/images/logo.png')),
      margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2.0),
    );

    final buttonAdd = Positioned(
      bottom: SizeConfig.safeBlockVertical * 0.2,
      right: SizeConfig.safeBlockHorizontal * 0.2,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TaskPage(
                        recordDataModel: null,
                      )));
        },
        child: Container(
          width: SizeConfig.safeBlockHorizontal * 15.0,
          height: SizeConfig.safeBlockVertical * 7.5,
          decoration: BoxDecoration(
              color: Color(0xFF7349FE),
              borderRadius:
                  BorderRadius.circular(SizeConfig.safeBlockHorizontal * 2.0)),
          child: Image(image: AssetImage('assets/images/add_icon.png')),
        ),
      ),
    );

    var loginButton = Center(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(
              new MaterialPageRoute(builder: (context) => LoginPage()));
        },
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.safeBlockVertical * 1.2,
              horizontal: SizeConfig.safeBlockHorizontal * 2.9),
          width: SizeConfig.safeBlockHorizontal * 30,
          height: SizeConfig.safeBlockVertical * 9.0,
          child: Text(
            'Silahkan login dulu.',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: SizeConfig.safeBlockHorizontal * 4.9),
          ),
          decoration: BoxDecoration(
              color: Color(0xFF7349FE),
              borderRadius:
                  BorderRadius.circular(SizeConfig.safeBlockHorizontal * 2.0)),
        ),
      ),
    );

    var loadingIndicator = Center(
      child: Container(
        child: CircularProgressIndicator(),
      ),
    );

    var listItemFromDB = Consumer<CRUD>(
        builder: (context, crudPersistanceSQLite, child) => Expanded(
            child: FutureBuilder<List<DataPersistanceSqlite>>(
                future: crudPersistanceSQLite.getTimerDataList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print('State: Waiting ....');
                    return Center(
                      child: Container(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    print('State: Completed...');

                    List<DataPersistanceSqlite> listItem = snapshot.data;

                    return ListView.builder(
                        itemCount: listItem?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            child: TaskCardWidget(
                              title: listItem[index].title,
                              description: listItem[index].desc,
                              timer: listItem[index].time,
                            ),
                            onTap: () {
                              print('tapped');
                              print(listItem[index].id);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TaskPage(
                                          recordDataModel: listItem[index])));
                            },
                            onLongPress: () {},
                          );
                        });
                  }
                })));

    var buttonSignedOut = Positioned(
        top: SizeConfig.safeBlockVertical * 1.0,
        right: SizeConfig.safeBlockHorizontal * 1.0,
        child: GestureDetector(
          onTap: () {
            print('button signed out pressed');
            signOutFromFirebase();
          },
          child: Container(
              width: SizeConfig.safeBlockHorizontal * 17.0,
              height: SizeConfig.safeBlockVertical * 5.0,
              decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(
                      SizeConfig.safeBlockHorizontal * 1.5)),
              child: Center(
                child: Text(
                  'Keluar',
                  style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              )),
        ));

    var ntuInfo = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5),
          child: Container(
            width: SizeConfig.safeBlockHorizontal * 20,
            height: SizeConfig.safeBlockVertical * 5.5,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3)),
            child: Center(
              child: Text(
                'Set NTU: ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.safeBlockHorizontal * 4.3,
                    color: Colors.black87),
              ),
            ),
          ),
        ),
        Consumer<ThresholdNTU>(
            builder: (context, test, child) => Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.safeBlockHorizontal * 50.0),
                  child: Text(
                    test.dataThreshold.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.safeBlockHorizontal * 4.3,
                        color: Colors.black),
                  ),
                )))
      ],
    );

    var servoInfo = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: EdgeInsets.only(left: SizeConfig.safeBlockHorizontal * 3.5),
          child: Container(
            width: SizeConfig.safeBlockHorizontal * 20,
            height: SizeConfig.safeBlockVertical * 5.5,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(3)),
            child: Center(
              child: Text(
                'Set Servo: ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.safeBlockHorizontal * 4.3,
                    color: Colors.black87),
              ),
            ),
          ),
        ),
        Consumer<ServoControl>(
            builder: (context, servo, child) => Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.safeBlockHorizontal * 50.0),
                  child: Text(
                    servo.dataServo.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.safeBlockHorizontal * 4.3,
                        color: Colors.black),
                  ),
                )))
      ],
    );

    var dataSensorRows = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Consumer<SensorNTUQuery>(
              builder: (context, ntu, child) => SensorData(
                    title: 'Data NTU',
                    data: ntu.dataNTU.toString(),
                  )),
          Consumer<SensorPakanIkanQuery>(
              builder: (context, tbd, child) => SensorData(
                  title: 'Data Pakan Ikan',
                  data: tbd.dataPakanIkan == 1 ? 'Tersedia' : 'Habis'))
        ],
      ),
    );

    var bannerInformasi = Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical * 2),
      child: Container(
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.safeBlockVertical * 2,
              horizontal: SizeConfig.safeBlockHorizontal * 2),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(SizeConfig.safeBlockHorizontal * 2),
              color: Colors.white),
          child: Column(
            children: [
              Text('Informasi Sensor',
                  style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 6.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54)),
              SizedBox(height: SizeConfig.safeBlockVertical * 2.6),
              GestureDetector(
                onTap: () {
                  showAlertSetNTU(context);
                  print('ntu info tapped');
                },
                child: ntuInfo,
              ),
              SizedBox(height: SizeConfig.safeBlockVertical * 2.0),
              GestureDetector(
                onTap: () {
                  print('servo info tapped');
                  showAlertSetServo(context);
                },
                child: servoInfo,
              ),
              SizedBox(height: SizeConfig.safeBlockVertical * 2),
              Divider(
                height: SizeConfig.safeBlockVertical * 2,
              ),
              dataSensorRows
            ],
          )),
    );

    var listItemsDB = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [newLogo, bannerInformasi, listItemFromDB],
    );

    var itemsLoggedIn = Stack(
      children: [listItemsDB, buttonAdd, buttonSignedOut],
    );

    return Scaffold(
      body: SafeArea(
        child: Container(
            color: Color(0xFFF6F6F6),
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.safeBlockVertical * 3.0,
                horizontal: SizeConfig.safeBlockHorizontal * 6.0),
            child: Consumer<BlocUser>(
                builder: (context, blocUser, _) => (resultRecordedLogin ==
                        "null")
                    ? loadingIndicator
                    : (resultRecordedLogin == "getLoginRecordFromSF-success")
                        ? itemsLoggedIn
                        : loginButton)),
      ),
    );
  }
}
