import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:test/controller/db_controller.dart'; // Importing database controller
import 'package:timezone/timezone.dart'
    as tz; // Importing timezone functionality

class AlarmModel extends ChangeNotifier {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  List<Map<String, dynamic>> alarms = []; // List to store alarm data

  // Constructor to initialize the notifications and load alarms from database
  AlarmModel() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeNotifications();
    _loadAlarms();
  }

  // Initializing local notifications plugin
  void _initializeNotifications() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Loading alarms from the database
  Future<void> _loadAlarms() async {
    final dbAlarms = await DatabaseHelper().getAlarms();
    alarms =
        List<Map<String, dynamic>>.from(dbAlarms); // Ensure it's a mutable list
    notifyListeners();
  }

  // Adding a new alarm
  Future<void> addAlarm(DateTime scheduledNotificationDateTime) async {
    final id =
        await DatabaseHelper().insertAlarm(scheduledNotificationDateTime);
    alarms.add(
        {'id': id, 'time': scheduledNotificationDateTime.toIso8601String()});
    scheduleAlarm(scheduledNotificationDateTime, id);
    notifyListeners();
  }

  // Deleting an alarm
  Future<void> deleteAlarm(int id) async {
    await DatabaseHelper().deleteAlarm(id);
    alarms.removeWhere((alarm) => alarm['id'] == id);
    cancelAlarm(id);
    notifyListeners();
  }

  // Updating an existing alarm
  Future<void> updateAlarm(int id, DateTime newTime) async {
    await DatabaseHelper().updateAlarm(id, newTime);
    final index = alarms.indexWhere((alarm) => alarm['id'] == id);
    if (index != -1) {
      alarms[index]['time'] = newTime.toIso8601String();
    }
    scheduleAlarm(newTime, id);
    notifyListeners();
  }

  // Scheduling an alarm notification
  Future<void> scheduleAlarm(
      DateTime scheduledNotificationDateTime, int id) async {
    final now = DateTime.now();

    if (scheduledNotificationDateTime.isBefore(now)) {
      scheduledNotificationDateTime =
          scheduledNotificationDateTime.add(Duration(days: 1));
    }

    final scheduledTZDate =
        tz.TZDateTime.from(scheduledNotificationDateTime, tz.local);
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      icon: '@mipmap/ic_launcher',
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Your scheduled alarm',
      '$scheduledNotificationDateTime',
      scheduledTZDate,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Cancelling an alarm
  Future<void> cancelAlarm(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
