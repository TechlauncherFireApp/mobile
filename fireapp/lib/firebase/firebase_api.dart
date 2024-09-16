import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print('Token: $fcmToken');

    initPushNotifications();
    initLocalNotifications();
  }

  Future<void> initPushNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            importance: Importance.max,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: message.data['route'],
      );
    });

  }

  Future<void> initLocalNotifications() async {
    const android = AndroidInitializationSettings('@drawable/notification_icon');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await _localNotifications.initialize(settings);

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(
      const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.max,
      ),
    );
  }
}