import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class BlocNotification extends ChangeNotifier {
  factory BlocNotification() => _instance;

  BlocNotification._internal();

  static final _instance = BlocNotification._internal();

  FlutterLocalNotificationsPlugin flutterLocalNotifPlugin =
      FlutterLocalNotificationsPlugin();

  // initialize local notification
  AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('medicines');
  IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings();
  MacOSInitializationSettings initializationSettingsMacOS =
      MacOSInitializationSettings();
  InitializationSettings initializationSettings;

  void initializing() async {
    initializationSettingsAndroid = AndroidInitializationSettings('medicines');
    initializationSettingsIOS = IOSInitializationSettings();
    initializationSettingsMacOS = MacOSInitializationSettings();

    initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);

    await flutterLocalNotifPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payLoad) {
    if (payLoad != null) {
      print(payLoad);
    }
  }

  void showNotification(String data) async {
    print('alarmHandle - schedule');
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotifPlugin.show(
        0, 'Reminder Kondisi Aquarium', '$data', platformChannelSpecifics,
        payload: 'item x');
  }

  void cancelNotif() async {
    await flutterLocalNotifPlugin.cancelAll();
  }

  Future<void> repeatNotification() async {
    // const AndroidNotificationDetails androidPlatformChannelSpecifics =
    //     AndroidNotificationDetails('repeating channel id',
    //         'repeating channel name', 'repeating description');
    // const NotificationDetails platformChannelSpecifics =
    //     NotificationDetails(android: androidPlatformChannelSpecifics);
    // await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
    //     'repeating body', RepeatInterval.everyMinute, platformChannelSpecifics,
    //     androidAllowWhileIdle: true);
  }

  void periodicAlarm() async {
    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //     0,
    //     'scheduled title',
    //     'scheduled body',
    //     tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
    //     const NotificationDetails(
    //         android: AndroidNotificationDetails('your channel id',
    //             'your channel name', 'your channel description')),
    //     androidAllowWhileIdle: true,
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.absoluteTime);
  }
}

// Create instance for all(s)
BlocNotification blocNotificationInstance = BlocNotification();
