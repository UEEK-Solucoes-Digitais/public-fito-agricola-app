import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';

class FirebaseToken {
  static getDeviceFirebaseToken() async {
    try {
      bool isLogged = await PrefUtils().isLogged();

      if (isLogged) {
        Admin admin = PrefUtils().getAdmin();

        if (admin.tokens != null) {
          FirebaseMessaging.instance.getToken().then((value) async {
            bool hasToken = false;

            for (var token in admin.tokens!) {
              if (token.token == value.toString()) {
                hasToken = true;
                break;
              }
            }

            if (!hasToken) {
              PrefUtils().setFirebaseToken(value.toString());

              DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

              String? info = '';

              if (Platform.isIOS) {
                var iosDeviceInfo = await deviceInfo.iosInfo;
                info = iosDeviceInfo.identifierForVendor;
              } else if (Platform.isAndroid) {
                var androidDeviceInfo = await deviceInfo.androidInfo;
                info = androidDeviceInfo.id;
              }

              DefaultRequest.simplePostRequest(
                ApiRoutes.updateToken,
                {
                  "user_id": admin.id.toString(),
                  "notification_token": value.toString(),
                  "device_id": info,
                },
                null,
                showSnackBar: 0,
              ).then((value) {
                if (value) {
                  print("Token atualizado com sucesso");
                }
              }).catchError((error) {
                print(error);
              });
            }
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
