import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitoagricola/core/utils/firebase_token.dart';
import 'package:fitoagricola/core/utils/notification_service.dart';

class FirebaseMessagingService {
  final NotificationService _notificationService;

  FirebaseMessagingService(this._notificationService);

  static Future<void> onBackgroundMessageReceived(RemoteMessage message) async {
    // RemoteNotification? notification = message.notification;

    // if (notification == null || notification.title == null) return;

    // AppLogger.initialize();

    // AppLogger.debug(
    //     'Notification received on background: ${notification.title}');

    // var notificationAction = NotificationAction.fromNotificationTitle(
    //     notification.title ?? '', notification.body);

    // var mustPlaySound = notificationAction.soundName != null;

    // if (mustPlaySound) {
    //   RingtoneService.playSound(
    //     notificationAction.soundName!,
    //     looping: true,
    //   );
    // }

    // if (isAutoShowScreenNotification(notification.title)) {
    //   return await NotificationActionService.executeAction(
    //     notificationTitle: notification.title,
    //     notificationBody: notification.body,
    //     args: message.data,
    //   );
    // }
    // AppLogger.debug('Notification will be shown on background');
  }

  Future<void> initialize() async {
    final instance = await FirebaseMessaging.instance;

    NotificationSettings settings = await instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    instance.setForegroundNotificationPresentationOptions(
      badge: true,
      sound: true,
      alert: true,
    );

    FirebaseToken.getDeviceFirebaseToken();

    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isIOS) {
        return;
      }

      RemoteNotification? notification = message.notification;

      print("message ${message.data['extras']}");

      if (notification != null) {
        _notificationService.showNotification(
          CustomNotification(
            id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
            title: notification.title,
            body: notification.body,
            payload: message.data['extras'] ?? '',
          ),
        );
      }
    });

    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   _handleMessage(message);
    // });

    // Verifica se o app foi aberto por uma notificação enquanto estava fechado
    // RemoteMessage? initialMessage =
    //     await FirebaseMessaging.instance.getInitialMessage();
    // if (initialMessage != null) {
    //   _handleMessage(initialMessage);
    // }
  }

  // void _handleMessage(RemoteMessage message) {
  //   final Map<String, dynamic> data = message.data;
  //   final String? payload = data['extras'];

  //   if (payload != null && payload.isNotEmpty) {
  //     _notificationService.handleNotificationPayload(payload);
  //   }
  // }
}
