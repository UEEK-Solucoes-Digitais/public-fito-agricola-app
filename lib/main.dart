import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitoagricola/core/utils/check_validation.dart';
import 'package:fitoagricola/core/utils/firebase_messaging_services.dart';
import 'package:fitoagricola/core/utils/notification_service.dart';
import 'package:fitoagricola/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:provider/provider.dart' as provider;
import 'package:provider/provider.dart';

import 'core/app_export.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   if (!PrefUtils().checkSync()) {
//     Workmanager().executeTask((taskName, inputData) async {
//       return PrefUtils().syncOffline();
//     });
//   }
// }

@pragma('vm:entry-point')
void handleMessage(
    RemoteMessage message, NotificationService notificationService) {
  final Map<String, dynamic> data = message.data;
  final String? payload = data['extras'];

  if (payload != null && payload.isNotEmpty) {
    notificationService.handleNotificationPayload(payload);
  }
}

Future main() async {
  await dotenv.load();
  final notificationService = NotificationService();
  notificationService.initialize();
  notificationService.setNavigatorKey(NavigatorService.navigatorKey);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await notificationService.checkForNotifications();

  await FirebaseMessagingService(notificationService).initialize();

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    handleMessage(message, notificationService);
  });

  await PrefUtils().init();

  await CheckValidation.checkValidation();

  WidgetsFlutterBinding.ensureInitialized();
  Future.wait([
    FlutterDownloader.initialize(debug: true, ignoreSsl: true),
    FMTCObjectBoxBackend().initialise(),
  ]).then((value) {
    runApp(
      MultiProvider(
        providers: [
          provider.Provider<NotificationService>(
            create: (context) => NotificationService(),
          ),
          provider.Provider<FirebaseMessagingService>(
            create: (context) => FirebaseMessagingService(
              context.read<NotificationService>(),
            ),
          ),
        ],
        child: ProviderScope(
          child: MyApp(),
        ),
      ),
    );
  });
}

// ignore: must_be_immutable
class MyApp extends ConsumerWidget {
  // final test = NetworkOperations.checkPostQueue();

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    return FutureBuilder(
      future: PrefUtils().isLogged(),
      builder: (context, snapshot) {
        bool isLogged = snapshot.data ?? false;

        return Sizer(
          builder: (context, orientation, deviceType) {
            return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: MaterialApp(
                theme: theme,
                title: 'Fito Agrícola',
                navigatorKey: NavigatorService.navigatorKey,
                debugShowCheckedModeBanner: false,
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [Locale('pt', 'BR')],
                initialRoute:
                    isLogged ? AppRoutes.homeScreen : AppRoutes.loginScreen,
                routes: AppRoutes.routes,
              ),
            );
          },
        );
      },
    );
  }
}
