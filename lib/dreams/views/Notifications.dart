
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
                              //Example Code by vijaycreations's tutorial on Youtube: https://www.youtube.com/watch?v=26TTYlwc6FM
class NotificationService{
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('flutter logo');
    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {});
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {} );
  }
  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max)
    );
  }
  Future showNotification(
      {int id =0 , String? title, String? body}) async {
        return notificationsPlugin.show(
          id, title, body, await notificationDetails());

  }
  Future scheduleNotification(
      { int id = 0,
        String? title,
        String? body,
        required DateTime scheduledNotificationDateTime}) async{
      var tz;
      return notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
          scheduledNotificationDateTime,
          tz.local,
        ),
        await notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);

     }



}