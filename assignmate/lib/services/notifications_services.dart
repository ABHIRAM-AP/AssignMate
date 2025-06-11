import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsServices {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
    'assignmate_channel',
    'Assignment Notifications',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );

  static const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

  Future<void> initNotifications() async {
    NotificationSettings settings = await _messaging.requestPermission();
    debugPrint(
        "Notification Permission Status ${settings.authorizationStatus}");

    const InitializationSettings initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await flutterLocalNotificationsPlugin.initialize(initSettings);

    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  Future<void> showLocalNotification({
    required String title,
    String body = '',
  }) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  void handleRemoteMessage(RemoteMessage message) {
    final title = message.notification?.title ?? "New Assignment";
    final body = message.notification?.body ?? "Tap to open";
    showLocalNotification(title: title, body: body);
  }
}
