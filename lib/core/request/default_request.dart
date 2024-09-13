import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/error_log.dart';
import 'package:fitoagricola/core/request/post_request_operations.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/core/utils/check_validation.dart';
import 'package:fitoagricola/core/utils/network_operations.dart';
import 'package:fitoagricola/core/utils/permissions.dart';
import 'package:fitoagricola/core/utils/validation_functions.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:fitoagricola/widgets/custom_elevated_button.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/dialogs.dart';
import 'package:fitoagricola/widgets/snackbar/snackbar_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class DefaultRequest {
  static bool validateInputs(body, context) {
    if (body['email'] != null && !isValidEmail(body['email'])) {
      SnackbarComponent.showSnackBar(
          context, 'alert', 'Utilize um e-mail válido no formulário.');
      return false;
    }

    return true;
  }

  static bool isDialogOpen(BuildContext context) {
    return ModalRoute.of(context)?.isCurrent == false;
  }

  static Future<bool> simplePostRequest(
    String url,
    Map<String, dynamic> body,
    BuildContext? context, {
    void Function()? redirectFunction,
    showSnackBar = 1,
    bool isMultipart = false,
    List? files,
    List? offlineFiles,
    bool closeModal = true,
  }) async {
    await CheckValidation.checkValidation();

    if (context != null && closeModal) {
      while (isDialogOpen(context)) {
        Navigator.pop(context);
      }

      if (showSnackBar == 1) {
        SnackbarComponent.showSnackBar(
            context, 'loading', 'Aguarde enquanto a operação é realizada');
      }
    }

    try {
      final token = PrefUtils().getToken();

      if (!validateInputs(body, context)) {
        return false;
      }

      String? cookieHectare = PrefUtils().getAreaUnit();

      String finalUrl = "${dotenv.env['API_URL']}${url}";

      if (cookieHectare == "alq") {
        finalUrl += finalUrl.contains('?')
            ? "&convert_to_alq=${true}"
            : "?convert_to_alq=${true}";
      }

      ConnectivityResult connectionType =
          await NetworkOperations.checkConnectionType();

      bool hasInternet = false;

      if (connectionType == ConnectivityResult.none) {
        hasInternet = false;
      } else {
        if (connectionType == ConnectivityResult.wifi) {
          hasInternet = true;
        } else if (connectionType == ConnectivityResult.mobile) {
          if (context != null && !onlyOnlineRoutes(url)) {
            Completer<String?> completer = Completer<String?>();

            Dialogs.showGeralDialog(
              context,
              title: "Tipo de conexão",
              text:
                  "Identificamos que você está utilizando os dados móveis, você deseja utilizar a sua conexão para enviar as informações ou armazenar a operação localmente para sincronizar no momento que conectar ao Wi-fi?",
              widget: Column(
                children: [
                  CustomFilledButton(
                    text: "Enviar Requisição",
                    onPressed: () {
                      completer.complete('yes');

                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomElevatedButton(
                    text: "Armazenar Localmente",
                    onPressed: () {
                      completer.complete('no');

                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            );

            String? result = await completer.future;

            if (result == null) hasInternet = true;

            if (result == 'yes') {
              PrefUtils().setOfflinePostOption(true);
              hasInternet = true;
            } else if (result == 'no') {
              PrefUtils().setOfflinePostOption(false);
              hasInternet = false;
            }
            // } else if (PrefUtils().checkOfflinePostOption() != null) {
            //   hasInternet = PrefUtils().checkOfflinePostOption()!;
          } else {
            hasInternet = true;
          }
        }
      }

      if (hasInternet) {
        return await PostRequestOperations.processPostRequest(
          finalUrl,
          token,
          body,
          context,
          redirectFunction: redirectFunction,
          showSnackBar: showSnackBar,
          isMultipart: isMultipart,
          files: files,
        );
      } else {
        if (onlyOnlineRoutes(url)) {
          return false;
        }

        return await PostRequestOperations.saveRequestLocally(
          finalUrl,
          token,
          body,
          context,
          redirectFunction: redirectFunction,
          showSnackBar: showSnackBar,
          isMultipart: isMultipart,
          files: offlineFiles,
        );
      }
    } catch (e, stackTrace) {
      ErrorLog.logError(e.toString(), stackTrace);
      Logger().e(e);
      if (showSnackBar == 1 && context != null) {
        SnackbarComponent.showSnackBar(context, 'error',
            "Erro ao realizar a operação. Tente novamente mais tarde.");
      }
      return false;
    }
  }

  // get
  static Future<http.Response> simpleGetRequest(
    String url,
    BuildContext? context, {
    int showSnackBar = 1,
    String textSnackBar = "Buscando informações",
    int durationSnackbar = 50,
  }) async {
    try {
      await CheckValidation.checkValidation();

      if (showSnackBar == 1 && context != null) {
        if (isDialogOpen(context)) {
          Navigator.pop(context);
        }

        SnackbarComponent.showSnackBar(
          context,
          'loading',
          textSnackBar,
          duration: Duration(
            seconds: durationSnackbar,
          ),
        );
      }

      final token = await PrefUtils().getToken();

      String finalUrl = "${dotenv.env['API_URL']}${url}";

      String? cookieHectare = PrefUtils().getAreaUnit();

      if (cookieHectare == "alq") {
        finalUrl += finalUrl.contains('?')
            ? "&convert_to_alq=${true}"
            : "?convert_to_alq=${true}";
      }

      ConnectivityResult connectionType =
          await NetworkOperations.checkConnectionType();

      bool hasInternet = false;
      bool hasLocally = false;

      if (connectionType == ConnectivityResult.none) {
        hasInternet = false;
      } else {
        if (connectionType == ConnectivityResult.wifi) {
          hasInternet = true;
        } else if (connectionType == ConnectivityResult.mobile) {
          hasInternet = true;

          if (await PrefUtils().getSQLOfflineData(finalUrl) != null) {
            hasLocally = true;
          }
        }

        if (await PrefUtils().getSQLOfflineData(finalUrl) != null) {
          hasLocally = true;
        }
      }
      print([hasLocally, finalUrl]);

      if (hasInternet) {
        if (hasLocally &&
            connectionType != ConnectivityResult.wifi &&
            !finalUrl.contains(ApiRoutes.listNotifications) &&
            !finalUrl.contains(ApiRoutes.listContents) &&
            !finalUrl.contains(ApiRoutes.listContentCategories) &&
            !finalUrl.contains(ApiRoutes.readContent) &&
            !finalUrl.contains(ApiRoutes.getOfflineFirstPart) &&
            !finalUrl.contains(ApiRoutes.getPartialSincronization) &&
            !finalUrl.contains(ApiRoutes.getOfflineSecondPart)) {
          final response = await http.get(Uri.parse(finalUrl), headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            "Authorization": "Bearer ${token}",
          }).timeout(
            const Duration(seconds: 2),
            onTimeout: () async {
              print('não deu');
              final body = await PrefUtils().getSQLOfflineData(finalUrl);
              return http.Response(
                body is String ? body : jsonEncode(body),
                200,
              );
            },
          );

          if (!finalUrl.contains(ApiRoutes.getOfflineFirstPart) &&
              !finalUrl.contains(ApiRoutes.listNotifications) &&
              !finalUrl.contains(ApiRoutes.listContents) &&
              !finalUrl.contains(ApiRoutes.listContentCategories) &&
              !finalUrl.contains(ApiRoutes.readContent) &&
              !finalUrl.contains(ApiRoutes.getPartialSincronization) &&
              !finalUrl.contains(ApiRoutes.getOfflineSecondPart)) {
            await PrefUtils().setSQLOfflineData(finalUrl, response.body);
          }
          return response;
        } else {
          final response = await http.get(Uri.parse(finalUrl), headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            "Authorization": "Bearer ${token}",
          });

          if (!finalUrl.contains(ApiRoutes.getOfflineFirstPart) &&
              !finalUrl.contains(ApiRoutes.getPartialSincronization) &&
              !finalUrl.contains(ApiRoutes.getOfflineSecondPart)) {
            await PrefUtils().setSQLOfflineData(finalUrl, response.body);
          }

          if (showSnackBar == 1 &&
              context != null &&
              response.statusCode == 200) {
            SnackbarComponent.showSnackBar(
              context,
              'success',
              'Informações carregadas com sucesso',
            );
          }
          // Logger().e(response);
          return response;
        }
      } else {
        if (onlyOnlineRoutes(finalUrl)) {
          return http.Response(jsonEncode({}), 400);
        }

        final response = await PrefUtils().getSQLOfflineData(finalUrl);

        if (response != null) {
          String jsonResponse =
              response is String ? response : jsonEncode(response);
          return http.Response(jsonResponse, 200);
        } else {
          SnackbarComponent.showSnackBar(context!, 'warning',
              'Algumas leituras não estão disponíveis por não terem sido feitas quando havia internet.');
          return http.Response(jsonEncode({}), 200);
        }
      }
    } catch (e, stackTrace) {
      ErrorLog.logError(e.toString(), stackTrace);
      Logger().e(e);
      return http.Response(jsonEncode({}), 400);
    }
  }

  static void exportFile(BuildContext context, String url) async {
    simpleGetRequest(
      url,
      context,
      textSnackBar: "Exportando arquivo",
      durationSnackbar: 500,
    ).then((value) async {
      final data = jsonDecode(value.body);
      if (data['status'] == 200 && data['file_dump'] != null) {
        SnackbarComponent.showSnackBar(
            context, "success", "Arquivo exportado com sucesso");

        final file = data['file_dump'];
        final fileName = data['file_name'];

        bool hasPermission =
            await PermissionsComponent.checkAndRequestStoragePermission();

        if (hasPermission) {
          try {
            await PermissionsComponent.downloadFile(file, fileName, context);
          } catch (e) {
            print("An error occurred while saving the file: $e");
            SnackbarComponent.showSnackBar(
                context, "error", "Ocorreu um erro ao salvar o arquivo.");
          }
        } else {
          SnackbarComponent.showSnackBar(context, "error",
              "Não foi possível realizar o download. Permissão de armazenamento não concedida. Habilite nas configurações do dispositivo.");
        }
      } else {
        Logger().e(data);
        SnackbarComponent.showSnackBar(
            context, "error", "Erro ao exportar arquivo");
      }
    }).catchError((error, stackTrace) {
      ErrorLog.logError(error.toString(), stackTrace);
      Logger().e(error);
      SnackbarComponent.showSnackBar(
          context, "error", "Erro ao exportar arquivo");
    });
  }

  static Future<bool> deleteMonitoring(
      BuildContext context, int id, String type) async {
    Admin admin = PrefUtils().getAdmin();

    Dialogs.showDeleteDialog(context,
        title: "Remover monitoramento",
        text: "Deseja realmente remover esse lançamento do monitoramento?",
        textButton: "Remover", onClick: () async {
      return await simplePostRequest(
        ApiRoutes.deleteItem,
        {
          "id": id,
          "type": type,
          "admin_id": admin.id,
          "_method": "PUT",
        },
        context,
      );
    });

    return false;
  }

  static Future<bool> getOffline() async {
    return true;
  }

  static bool onlyOnlineRoutes(String url) {
    List<String> routes = [
      ApiRoutes.login,
      ApiRoutes.appVersion,
      ApiRoutes.updateToken,
      ApiRoutes.getOfflineFirstPart,
      ApiRoutes.getOfflineSecondPart,
    ];

    bool isOffline = false;

    for (var route in routes) {
      if (url.contains(route)) {
        isOffline = true;
        break;
      }
    }
    return isOffline;
  }

  static Future<bool> refreshToken() async {
    try {
      bool hasConnection = await NetworkOperations.checkConnection();

      if (!hasConnection) {
        return false;
      }

      final body = {
        "email": dotenv.env['API_EMAIL'],
        "password": dotenv.env['API_PASSWORD'],
      };

      String finalUrl = "${dotenv.env['API_URL']}${ApiRoutes.loginApi}";

      final request = await http.post(
        Uri.parse(finalUrl),
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).catchError((error, stackTrace) {
        ErrorLog.logError(error.toString(), stackTrace);
        Logger().e(error);
      });

      final bodyResponse = jsonDecode(request.body);
      final statusCode = request.statusCode;

      if (statusCode == 200) {
        final token = bodyResponse['access_token'];
        final expiration = bodyResponse['expires_in'];

        // expiration vem em minutos, entao adicionamos à data atual e armazenamos no shared preferences no formato dd-mm-yyyy HH:mm:ss
        DateTime expirationDate =
            DateTime.now().add(Duration(minutes: expiration));

        PrefUtils().setToken(token);
        PrefUtils().setTokenExpires(expirationDate.toString());

        return true;
      } else {
        return false;
      }
    } catch (e, stackTrace) {
      ErrorLog.logError(e.toString(), stackTrace);
      Logger().e(e);
      return false;
    }
  }
}
