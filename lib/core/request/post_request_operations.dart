import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/error_log.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';
import 'package:fitoagricola/widgets/snackbar/snackbar_component.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class PostRequestOperations {
  static Future<bool> processPostRequest(
    String finalUrl,
    String token,
    Map<String, dynamic> body,
    BuildContext? context, {
    void Function()? redirectFunction,
    showSnackBar = 1,
    bool isMultipart = false,
    List? files,
  }) async {
    try {
      var request;
      String msg = "";
      var bodyResponse;
      int statusCode = 200;

      if (isMultipart) {
        request = http.MultipartRequest('POST', Uri.parse(finalUrl));
        request.headers.addAll({
          'Accept': 'application/json',
          "Authorization": "Bearer ${token}",
        });

        request.fields.addAll(body);

        if (files != null) {
          // request.files.addAll(files);

          for (var file in files) {
            request.files.add(file);
          }
        }

        await request.send().then((result) async {
          await http.Response.fromStream(result).then((response) async {
            bodyResponse = jsonDecode(response.body);

            statusCode = response.statusCode;
          }).catchError((error, stackTrace) {
            statusCode = 500;
            ErrorLog.logError(e.toString(), stackTrace);

            Logger().e(error);
            if (showSnackBar == 1 && context != null) {
              SnackbarComponent.showSnackBar(context, 'error',
                  "Erro ao realizar a operação. Tente novamente mais tarde.");
            }
          });
        });
      } else {
        try {
          request = await http.post(
            Uri.parse(finalUrl),
            body: jsonEncode(body),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              "Authorization": "Bearer ${token}"
            },
          ).catchError((error, stackTrace) {
            ErrorLog.logError(e.toString(), stackTrace);
            Logger().e(error);
          });

          bodyResponse = jsonDecode(request.body);
          statusCode = request.statusCode;
        } catch (e, stackTrace) {
          ErrorLog.logError(e.toString(), stackTrace);
          Logger().e(e);
          if (showSnackBar == 1 && context != null) {
            SnackbarComponent.showSnackBar(context, 'error',
                "Erro ao realizar a operação. Tente novamente mais tarde.");
          }
        }
      }
      // Logger().e([statusCode, bodyResponse]);

      if (statusCode == 500) {
        msg = 'Erro ao realizar a operação';
      } else {
        msg = bodyResponse != null && bodyResponse['msg'] != null
            ? bodyResponse['msg']
            : statusCode == 200
                ? "Clique no botão abaixo para finalizar"
                : "Infelizmente não foi possível completar a operação. Tente novamente mais tarde.";
      }
      if (finalUrl.contains(ApiRoutes.login) &&
          statusCode == 200 &&
          bodyResponse['admin'] != null) {
        final admin = jsonEncode(bodyResponse['admin']);

        await PrefUtils().setLogged(true);
        await PrefUtils().setAdmin(admin);
      }

      if (finalUrl.contains(ApiRoutes.updateToken) &&
          statusCode == 200 &&
          bodyResponse['admin'] != null) {
        final admin = jsonEncode(bodyResponse['admin']);
        await PrefUtils().setAdmin(admin);
      }

      await (() async {
        if (showSnackBar == 1 && context != null) {
          SnackbarComponent.showSnackBar(
              context, statusCode == 200 ? 'success' : 'error', msg);
        }

        if (statusCode == 200) {
          Future.delayed(Duration(seconds: 2), () {
            redirectFunction?.call();
          });
        } else {}
      })();

      return statusCode == 200 ? true : false;
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

  static Future<bool> saveRequestLocally(
    String finalUrl,
    String token,
    Map<String, dynamic> body,
    BuildContext? context, {
    void Function()? redirectFunction,
    showSnackBar = 1,
    bool isMultipart = false,
    List? files,
  }) async {
    try {
      // Converta o corpo e os headers para JSON
      String bodyJson = jsonEncode(body);
      List<String> filePaths = [];

      // Se houver arquivos, salve os caminhos
      // Obter diretório seguro para armazenar arquivos
      final directory = await getApplicationDocumentsDirectory();

      // Se houver arquivos, salve os caminhos
      if (files != null && files.isNotEmpty) {
        for (var file in files) {
          try {
            // Verifique se o arquivo existe
            if (await File(file.path).exists()) {
              // Copiar arquivo para o diretório seguro
              final newPath =
                  path.join(directory.path, path.basename(file.path));
              await File(file.path).copy(newPath);
              print(newPath);
              filePaths.add(newPath);
            } else {
              Logger().e("File not found: ${file.path}");
            }
          } catch (e, stackTrace) {
            Logger().e("Error processing file ${file.path}: $e");
          }
        }
      }

      // Armazene a requisição com os caminhos dos arquivos
      double requestId = Random().nextDouble() * 256;

      String name = getName(finalUrl, body);
      final jsonToStore = {
        "name": name,
        "url": finalUrl,
        "body": bodyJson,
        "filePaths": filePaths,
        "timestamp": requestId,
        "status": 0,
      };

      PrefUtils().storePostRequest('request_${requestId}', jsonToStore);

      if (context != null) {
        SnackbarComponent.showSnackBar(
          context,
          'success',
          "Identificamos que você está sem internet! A operação foi salva localmente para ser sincronizada quando uma conexão for estabelecida.",
          duration: const Duration(seconds: 5),
        );
      }

      return true;
    } catch (e, stackTrace) {
      ErrorLog.logError(e.toString(), stackTrace);
      Logger().e(e);
      return false;
    }
  }

  static Future<bool> postOffline(dynamic operation) async {
    var request;
    var bodyResponse;
    int statusCode = 200;

    Map<String, String> body = {};
    // final files = jsonDecode(operation['filePaths']);
    final token = await PrefUtils().getToken();

    if (operation['url'].contains(ApiRoutes.formMonitoring)) {
      request = http.MultipartRequest('POST', Uri.parse(operation['url']));
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer ${token}"
      });

      jsonDecode(operation['body']).forEach((item, key) {
        body[item] = key is String ? key : key.toString();
      });

      request.fields.addAll(body);

      int imageIndex = 0;
      String code = 'stages';

      switch (body['type']) {
        case '1':
          code = "stages";
          break;
        case '2':
          code = "diseases";
          break;
        case '3':
          code = "pests";
          break;
        case '4':
          code = "weeds";
          break;
        case '5':
          code = "observations";
          break;
      }

      if (operation['filePaths'] != null && operation['filePaths'].isNotEmpty) {
        for (var filePath in operation['filePaths']) {
          try {
            var file = File(filePath);
            print(filePath);
            if (await file.exists()) {
              print('${filePath} exists');
              var multipartFile = http.MultipartFile(
                "${code}_images[${imageIndex}]",
                file.readAsBytes().asStream(),
                file.lengthSync(),
                filename: path.basename(file.path),
              );
              request.files.add(multipartFile);
              imageIndex++;
            } else {
              Logger().e("File not found: $filePath");
            }
          } catch (e, stackTrace) {
            Logger().e("Error processing file $filePath: $e");
          }
        }
      }
      await request.send().then((result) async {
        await http.Response.fromStream(result).then((response) async {
          bodyResponse = jsonDecode(response.body);

          statusCode = response.statusCode;

          // se sucesso, remove as imagens que estavam localmente
          if (statusCode == 200) {
            for (var filePath in operation['filePaths']) {
              try {
                var file = File(filePath);
                if (await file.exists()) {
                  await file.delete();
                }
              } catch (e, stackTrace) {
                Logger().e("Error deleting file $filePath: $e");
              }
            }
          }
        }).catchError((error, stackTrace) {
          statusCode = 500;

          ErrorLog.logError(e.toString(), stackTrace);
          Logger().e(error);
        });
      }).catchError((error, stackTrace) {
        statusCode = 500;

        ErrorLog.logError(e.toString(), stackTrace);
        Logger().e(error);
      });
    } else {
      try {
        request = await http.post(
          Uri.parse(operation['url']),
          body: jsonEncode(jsonDecode(operation['body'])),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            "Authorization": "Bearer ${token}"
          },
        );

        bodyResponse = jsonDecode(request.body);
        statusCode = request.statusCode;
      } catch (e, stackTrace) {
        Logger().e(e);
        ErrorLog.logError(e.toString(), stackTrace);
        statusCode = 500;
      }
    }
    return statusCode == 200 ? true : false;
  }

  static String getName(url, body) {
    if (url.contains("rain-gauge")) {
      return "Registro pluviômetro";
    } else if (url.contains(ApiRoutes.formManagamentData)) {
      switch (body['type']) {
        case 'seed':
          return "Dados de manejo - Sementes";
        case 'population':
          return "Dados de manejo - População";
        case 'fertilizer':
          return "Dados de manejo - Fertilizantes";
        case 'defensive':
          return "Dados de manejo - Defensivos";
        case 'harvest':
          return "Dados de manejo - Colheitas";
        default:
          return "Dados de manejo";
      }
    } else if (url.contains(ApiRoutes.deleteManagamentData)) {
      if (url.contains('seed')) {
        return "Dados de manejo - Deletar Semente";
      } else if (url.contains('population')) {
        return "Dados de manejo - Deletar População";
      } else if (url.contains('fertilizer')) {
        return "Dados de manejo - Deletar Fertilizantes";
      } else if (url.contains('defensive')) {
        return "Dados de manejo - Deletar Defensivos";
      } else if (url.contains('harvest')) {
        return "Dados de manejo - Deletar Colheitas";
      } else {
        return "Dados de manejo";
      }
    } else if (url.contains(ApiRoutes.formMonitoring)) {
      switch (body['type']) {
        case '1':
          return "Monitoramento - Estádio";
        case '2':
          return "Monitoramento - Doença";
        case '3':
          return "Monitoramento - Praga";
        case '4':
          return "Monitoramento - Daninha";
        case '5':
          return "Monitoramento - Observação";
        default:
          return "Monitoramento";
      }
    } else if (url.contains("image")) {
      return "Monitoramento - ${url.contains('delete') ? 'Deletar ' : ''}Imagem";
    } else if (url.contains(ApiRoutes.deleteMonitoring)) {
      return "Monitoramento - Remover";
    } else if (url.contains(ApiRoutes.changeDate)) {
      return "Monitoramento - Alterar data";
    } else if (url.contains(ApiRoutes.registerActivity)) {
      switch (body['type']) {
        case 'seed':
          return "Registrar atividades - Sementes";
        case 'fertilizer':
          return "Registrar atividades - Fertilizantes";
        case 'defensive':
          return "Registrar atividades - Defensivos";
        case 'harvest':
          return "Registrar atividades - Colheitas";
        default:
          return "Registrar atividades";
      }
    } else {
      return "Requisição genérica";
    }
  }
}
