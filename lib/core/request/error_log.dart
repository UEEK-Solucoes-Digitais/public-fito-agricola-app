import 'package:fitoagricola/core/request/default_request.dart';
import 'package:fitoagricola/core/utils/api_routes.dart';

class ErrorLog {
  static void logError(String error, StackTrace stackTrace) {
    if (error.contains("The error handler of ") || error.contains("2.7")) {
      return;
    }
    // Captura o nome do arquivo e a linha onde o erro ocorreu
    final errorDetails = {
      'error': error,
      'stackTrace': stackTrace.toString(),
      'location': getLocationFromStackTrace(stackTrace),
    };

    // Exibe no console para depuração
    print("logando: ${errorDetails['error']} em ${errorDetails['location']}");

    DefaultRequest.simplePostRequest(
      ApiRoutes.errorLog,
      {
        "environment": "app",
        "error": errorDetails['error'],
        "stack_trace": errorDetails['stackTrace'],
        "location": errorDetails['location'],
      },
      null,
    ).then((value) {
      if (!value) {
        print("Error logging error: ${errorDetails['error']}");
      }
    }).catchError((errorLog) {
      print("Error logging error: $errorLog");
    });
  }

  static String getLocationFromStackTrace(StackTrace stackTrace) {
    // Obtém a primeira linha da stack trace, que normalmente contém o arquivo e a linha onde ocorreu o erro
    final traceString = stackTrace.toString().split('\n').first;
    final indexOfFile = traceString.indexOf(RegExp(r'[A-Za-z_/]+.dart'));
    final location = traceString.substring(indexOfFile);
    return location;
  }
}
