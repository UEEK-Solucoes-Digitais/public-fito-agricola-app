import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/error_log.dart';
import 'package:fitoagricola/core/utils/network_operations.dart';
import 'package:fitoagricola/core/utils/notification_service.dart';
import 'package:logger/logger.dart';

Future<void> performBackgroundTask() async {
  // logando hora atual e conexção
  Logger().i([
    'Hora atual: ${DateTime.now()}',
    'Conexão: ${await NetworkOperations.checkConnectionType()}',
  ]);

  // Logger().i(['isInitialized: ${PrefUtils().isInitialized}']);

  // if (PrefUtils().isInitialized) {
  //   Logger().i([
  //     'isNetworkInitialized: ${await PrefUtils().isNotificationInitialized()}',
  //     'isSync: ${await PrefUtils().isSync()}',
  //   ]);
  // }

  if (!PrefUtils().isInitialized) {
    await PrefUtils().init();
  }

  // if (PrefUtils().isInitialized) {
  //   final notificationService = NotificationService();
  //   notificationService.initialize();

  //   if (await PrefUtils().isNotificationInitialized()) {
  if (!await PrefUtils().isSync()) {
    ConnectivityResult internetType =
        await NetworkOperations.checkConnectionType();
    print(internetType);

    if (internetType == ConnectivityResult.wifi) {
      List operations = PrefUtils().getAllPostRequest();
      print(operations.length);

      if (operations.isNotEmpty) {
        try {
          await NetworkOperations.checkPostQueue(showNotification: false);
        } catch (error, stackTrace) {
          ErrorLog.logError(error.toString(), stackTrace);
        }
      }
    }
  }
  // }
  // }
}
