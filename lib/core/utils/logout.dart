import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/core/utils/database_helper.dart';
import 'package:fitoagricola/core/utils/network_operations.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

// classe para logout e redirecionar pra home
class LogoutFunction extends StatelessWidget {
  const LogoutFunction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LogoutFunctionOperation(context);
    return Container();
  }
}

void LogoutFunctionOperation(BuildContext? context) async {
  // redireciona para a tela de login
  try {
    if (context != null) {
      Dialogs.showLoadingDialog(context);
    }
    // await PrefUtils().setAdmin('');
    // await PrefUtils().setLastSync('');
    // await PrefUtils().setSyncProperties('sync_properties', '');
    bool hasInternet = await NetworkOperations.checkConnection();
    if (hasInternet && PrefUtils().checkAdmin()) {
      await DefaultRequest.simplePostRequest(
        ApiRoutes.removeNotificationToken,
        {
          "admin_id": PrefUtils().getAdmin().id.toString(),
          "notification_token": PrefUtils().getFirebaseToken(),
        },
        context,
        showSnackBar: 0,
        closeModal: false,
      );
    }

    await PrefUtils().clearPreferencesData();
    await DatabaseHelper().removeAllData();
  } catch (e) {
    Logger().e(e);
  }
  if (context != null) {
    Navigator.pop(context);
  }
  PrefUtils().setLogged(false).then((value) {
    if (context != null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.loginScreen,
        (route) => false,
      );
    } else {
      NavigatorService.pushNamed(AppRoutes.loginScreen);
    }
  });
}
