import 'dart:async';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/error_log.dart';
import 'package:fitoagricola/core/utils/network_operations.dart';
import 'package:fitoagricola/core/utils/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:logger/logger.dart';

// Função para inicializar o serviço em segundo plano
Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: false,
      autoStart: true,
      // initialNotificationTitle: "Fito Agrícola",
      // initialNotificationContent: "Verificando conexão",
    ),
  );
}

// Função que é chamada quando o aplicativo está em segundo plano no iOS
@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

// Função que é chamada quando o serviço é iniciado (em segundo plano ou em primeiro plano)
@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    // service.on('setAsForeground').listen((event) {
    //   service.setAsForegroundService();
    // });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 20), (timer) async {
    if (PrefUtils().isInitialized) {
      await PrefUtils().reload();
      Logger().i([
        'Hora atual: ${DateTime.now()}',
        'Conexão: ${await NetworkOperations.checkConnectionType()}',
        'isSync: ${await PrefUtils().isSync()}',
      ]);
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
    }
    service.invoke("update");
  });
}
