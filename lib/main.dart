import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_getx/blocs/bloc_database/sensor_query.dart';
import 'package:todo_getx/blocs/bloc_database/servo_control.dart';
import 'package:todo_getx/blocs/bloc_database/threshold_ntu.dart';
import 'package:todo_getx/blocs/bloc_notification.dart';
import 'package:todo_getx/blocs/bloc_persist.dart';
import 'package:todo_getx/blocs/bloc_user.dart';
import 'package:todo_getx/screens/home_page.dart';
import 'package:todo_getx/screens/landing_page.dart';
import 'package:todo_getx/services/app_retain_widget.dart';

import 'package:flutter/services.dart';

import 'package:todo_getx/services/backgroundMain.dart';
import 'package:todo_getx/test_provider.dart';

void main() async {
  runApp(MyApp());
  // initial notification bloc
  blocNotificationInstance.initializing();

  // initial background service
  var channel = const MethodChannel('com.example/background_service');
  var callbackHandle = PluginUtilities.getCallbackHandle(backgroundMain);
  channel.invokeMethod('startService', callbackHandle.toRawHandle());
}

class MyApp extends StatefulWidget {
  static const String _title = 'Provider Sign-In Example';

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Firebase.initializeApp().whenComplete(() {
      print('[INITIAL FIREBASE COMPLETED]');
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppRetainWidget(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => BlocUser()),
          ChangeNotifierProvider(create: (context) => CRUD()),
          ChangeNotifierProvider(create: (context) => ThresholdNTU()),
          ChangeNotifierProvider(create: (context) => ServoControl()),
          ChangeNotifierProvider(create: (context) => TestProvider()),
          ChangeNotifierProvider(create: (context) => SensorNTUQuery()),
          ChangeNotifierProvider(create: (context) => SensorPakanIkanQuery())
        ],
        child: MaterialApp(
            theme: ThemeData(
                textTheme:
                    GoogleFonts.latoTextTheme(Theme.of(context).textTheme)),
            title: MyApp._title,
            home: HomePage(),
            debugShowCheckedModeBanner: false),
      ),
    );
  }
}
