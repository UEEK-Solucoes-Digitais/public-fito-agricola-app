import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fitoagricola/widgets/snackbar/snackbar_component.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:latlong2/latlong.dart' as latlgn;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class PermissionsComponent {
  static bool isRequestingPermission = false;

  static Future<bool> checkAndRequestStoragePermission() async {
    if (isRequestingPermission)
      return false; // Or handle this case differently based on your needs
    bool havePermission = false;

    if (Platform.isAndroid) {
      final DeviceInfoPlugin info =
          DeviceInfoPlugin(); // import 'package:device_info_plus/device_info_plus.dart';
      final AndroidDeviceInfo androidInfo = await info.androidInfo;

      final int androidVersion = int.parse(androidInfo.version.release);

      if (androidVersion >= 13) {
        final request = await [
          Permission.videos,
          Permission.photos,
        ].request();

        havePermission = request.values
            .every((status) => status == PermissionStatus.granted);
      } else {
        final status = await Permission.storage.request();
        havePermission = status.isGranted;
      }

      if (!havePermission) {
        // if no permission then open app-setting
        await openAppSettings();
      }
    } else {
      // final status = await Permission.storage.request();

      Map<Permission, PermissionStatus> statuses = await [
        Permission.photos,
        Permission.storage,
      ].request();

      if (!statuses[Permission.photos]!.isGranted ||
          !statuses[Permission.storage]!.isGranted) {
        // if no permission then open app-setting
        await openAppSettings();
      } else {
        havePermission = true;
      }
    }

    isRequestingPermission = false;
    return havePermission;
  }

  static Future<bool> checkAndRequestCameraPermission() async {
    if (isRequestingPermission)
      return false; // Or handle this case differently based on your needs
    bool havePermission = false;

    final status = await Permission.camera.request();
    if (!status.isGranted) {
      // if no permission then open app-setting
      await openAppSettings();
    } else {
      havePermission = true;
    }

    isRequestingPermission = false;
    return havePermission;
  }

  static Future<bool> checkAndRequestNotificationPermission() async {
    if (isRequestingPermission)
      return false; // Or handle this case differently based on your needs
    bool havePermission = false;

    final status = await Permission.notification.request();
    if (!status.isGranted) {
      // if no permission then open app-setting
      await openAppSettings();
    } else {
      havePermission = true;
    }

    isRequestingPermission = false;
    return havePermission;
  }

  // location
  static Future<bool> checkAndRequestLocationPermission() async {
    if (isRequestingPermission)
      return false; // Or handle this case differently based on your needs
    bool havePermission = false;

    final status = await Permission.location.request();
    if (!status.isGranted) {
      // if no permission then open app-setting
      await openAppSettings();
    } else {
      havePermission = true;
    }

    isRequestingPermission = false;
    return havePermission;
  }

  static Future<latlgn.LatLng>? getCurrentLocation() async {
    if (Platform.isAndroid) {
      GeolocatorAndroid.registerWith();
    } else if (Platform.isIOS) {
      GeolocatorApple.registerWith();
    }

    final positions = await Geolocator.getCurrentPosition();

    return latlgn.LatLng(positions.latitude, positions.longitude);
  }

  static Future<void> downloadFile(
      String url, String fileName, BuildContext context) async {
    String? documentPath = await getDownloadPath();

    if (documentPath == null) {
      return;
    }

    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: documentPath,
      fileName: fileName,
      showNotification: true,
      openFileFromNotification: true,
    ).then((value) {
      SnackbarComponent.showSnackBar(context, 'success',
          'Download iniciado, acompanhe pela barra de notificações');
    }).catchError((error) {
      print(error);
      SnackbarComponent.showSnackBar(
          context, 'error', 'Erro ao iniciar download');
    }).whenComplete(() {
      print('${documentPath}/${fileName}');
    });
    print(taskId);
    SnackbarComponent.showSnackBar(
      context,
      'success',
      'Download finalizado. Clique na notificação para abrir o arquivo.',
      duration: Duration(seconds: 20),
      onClick: () async {
        await OpenFilex.open('${documentPath}/${fileName}');
      },
    );
  }

  static Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists())
          directory = await getExternalStorageDirectory();
      }
    } catch (err) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }

  // gallery path
  static Future<String?> getGalleryPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = await getExternalStorageDirectory();
      }
    } catch (err) {
      print("Cannot get gallery folder path");
    }
    return directory?.path;
  }

  static Future<bool> photoManagerAccess() async {
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      return true;
    }
    PhotoManager.openSetting();
    return false;
  }
}
