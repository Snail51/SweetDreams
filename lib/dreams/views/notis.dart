/**

import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
  BehaviorSubject<ReceivedNotification>();

  NotificationAppLaunchDetails notificationAppLaunchDetails;

  Future<void> initNotifications() async {
    notificationAppLaunchDetails =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    var initializationSettingsAndroid =
    AndroidInitializationSettings('ic_launcher');

    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (
            int id,
            String title,
            String body,
            String payload,
            ) async {
          didReceiveLocalNotificationSubject.add(ReceivedNotification(
              id: id, title: title, body: body, payload: payload));
        });

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
          if (payload != null) {
            print('notification payload: ' + payload);
          }
        });
  }

  Future<void> showRandomSleepReminderNotification() async {
    var random = Random();
    List<String> messages = [
      'Time to sleep!',
      'Remember to get some rest.',
      'Your body needs rest. Sleep well!',
      'A good night\'s sleep is important for your health.',
      'Prioritize your sleep tonight.',
    ];

    var message = messages[random.nextInt(messages.length)];

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'sleep_reminder_channel_id',
        'Sleep Reminder Channel',
        'Channel for sleep reminder notifications',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Sleep Reminder',
      message,
      platformChannelSpecifics,
    );
  }
}

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    this.id,
    this.title,
    this.body,
    this.payload,
  });
}
    **/