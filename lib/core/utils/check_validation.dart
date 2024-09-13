import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/core/request/default_request.dart';

class CheckValidation {
  static checkValidation() async {
    final tokenItens = PrefUtils().getTokenSettings();
    print(tokenItens);

    // posição 1 é o token, posição 2 é a data de expiração no formato dd-mm-yyyy HH:mm:ss
    if (tokenItens.length == 2) {
      final token = tokenItens[0];
      final tokenExpiration = tokenItens[1];

      bool needRequest = false;

      if (token.isEmpty || tokenExpiration.isEmpty) {
        needRequest = true;
      } else {
        if (token.isNotEmpty &&
            tokenExpiration.isNotEmpty &&
            tokenExpiration != 'null' &&
            token != 'null') {
          final tokenExpirationDate = DateTime.parse(tokenExpiration);

          if (tokenExpirationDate.isBefore(DateTime.now())) {
            needRequest = true;
          }
        }
      }

      if (needRequest) {
        await DefaultRequest.refreshToken();
      }
    }
  }
}
