import 'package:fitoagricola/core/app_export.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class CustomNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  CustomNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}

class NotificationService {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidDetails;
  late DarwinNotificationDetails iosDetails;
  late GlobalKey<NavigatorState> navigatorKey;

  static final NotificationService _singleton = NotificationService._internal();

  factory NotificationService() {
    return _singleton;
  }

  NotificationService._internal();

  void initialize() {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _setupNotifications();
    PrefUtils().setNotificationInitialized(true);
  }

  void setNavigatorKey(GlobalKey<NavigatorState> key) {
    navigatorKey = key;
  }

  _setupNotifications() async {
    await _setupTimezone();
    await _initializeNotifications();
  }

  Future<void> _setupTimezone() async {
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }

  _initializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    await localNotificationsPlugin.initialize(
      const InitializationSettings(
        android: android,
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: _onSelectedNotification,
    );
  }

  _onSelectedNotification(NotificationResponse? payload) async {
    if (payload != null && payload.payload!.isNotEmpty) {
      handleNotificationPayload(payload.payload!);
    }
  }

  void handleNotificationPayload(String payload) async {
    List payloadList = payload.split("&");

    var objectId = 0;
    var contentType = 0;
    var pageSubType = '';

    for (var list in payloadList) {
      List stringResult = list.split("=");

      if (stringResult[0] == "object_id" && stringResult[1].isNotEmpty) {
        objectId = int.parse(stringResult[1]);
      }

      if (stringResult[0] == "subtype" && stringResult[1].isNotEmpty) {
        pageSubType = stringResult[1];
      }

      if (stringResult[0] == "content_type" && stringResult[1].isNotEmpty) {
        contentType = int.parse(stringResult[1]);
      }

      if (stringResult[0] == "type" && objectId != 0) {
        if (['management-data', 'informations', 'monitoring']
            .contains(stringResult[1])) {
          navigatorKey.currentState!.pushNamed(
            AppRoutes.cropJoinPage,
            arguments: {
              'cropJoinId': objectId,
              'page': stringResult[1],
              'pageSubType': pageSubType,
            },
          );
        } else if (stringResult[1] == 'contents') {
          navigatorKey.currentState!.pushNamed(
            AppRoutes.publicationListPage,
            arguments: {
              'publicationId': objectId,
              'contentType': contentType,
            },
          );
        }
      }
    }
  }

  showNotification(CustomNotification notification) {
    androidDetails = const AndroidNotificationDetails(
      'notifications',
      "Notificação",
      importance: Importance.max,
      priority: Priority.max,
      icon: '@drawable/ic_notification',
    );

    iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    localNotificationsPlugin.show(
      notification.id,
      notification.title,
      notification.body,
      NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
      payload: notification.payload,
    );
  }

  checkForNotifications() async {
    final details =
        await localNotificationsPlugin.getNotificationAppLaunchDetails();

    if (details != null) {
      _onSelectedNotification(details.notificationResponse);
    }
  }
}
