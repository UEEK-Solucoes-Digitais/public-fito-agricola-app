import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/error_log.dart';
import 'package:fitoagricola/core/request/post_request_operations.dart';
import 'package:fitoagricola/core/utils/notification_service.dart';
import 'package:logger/logger.dart';

class NetworkOperations {
  static Future<bool> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    return true;
  }

  static Future<ConnectivityResult> checkConnectionType() async {
    return await (Connectivity().checkConnectivity());
  }

  static Future<void> checkPostQueue() async {
    try {
      bool hasConnection = await checkConnection();

      if (hasConnection) {
        List operations = PrefUtils().getAllPostRequest();

        if (operations.isNotEmpty) {
          await NotificationService().showNotification(
            CustomNotification(
              id: 0,
              title: 'Sincronizando',
              body: "Enviando lançamentos offline para o sistema",
              payload: 'offline_sync',
            ),
          );

          for (var operation in operations) {
            // PrefUtils().storePostRequest("request_${operation['timestamp']}", {
            //   "name": operation['name'],
            //   "url": operation['url'],
            //   "body": operation['body'],
            //   "filePaths": operation['filePaths'],
            //   "timestamp": operation['timestamp'],
            //   "status": 1,
            // });
            // print(operation);
            await PostRequestOperations.postOffline(operation).then(
              (value) async {
                if (value) {
                  await PrefUtils()
                      .removePostRequest("request_${operation['timestamp']}");
                } else {
                  await PrefUtils()
                      .storePostRequest("request_${operation['timestamp']}", {
                    "name": operation['name'],
                    "url": operation['url'],
                    "body": operation['body'],
                    "filePaths": operation['filePaths'],
                    "timestamp": operation['timestamp'],
                    "status": 3,
                  });

                  NotificationService().showNotification(
                    CustomNotification(
                      id: 0,
                      title: 'Erro',
                      body:
                          "Erro ao enviar ${operation['name']} offline para o sistema",
                      payload: 'offline_sync',
                    ),
                  );
                }
              },
            ).catchError((error, stackTrace) {
              ErrorLog.logError(error.toString(), stackTrace);
              Logger().e(error);
            });
          }
        }
      }
    } catch (e, stackTrace) {
      ErrorLog.logError(e.toString(), stackTrace);
      Logger().e(e);
    }
  }
}
