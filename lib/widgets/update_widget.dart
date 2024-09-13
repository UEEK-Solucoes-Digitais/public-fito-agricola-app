import 'dart:io';

import 'package:fitoagricola/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateWidget extends StatelessWidget {
  const UpdateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 100,
          ),
          const SizedBox(height: 20),
          Text(
            'Atualize o aplicativo para continuar utilizando.',
            style: TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          CustomElevatedButton(
            text: "Atualizar",
            onPressed: () async {
              String link = '';
              if (Platform.isAndroid) {
                link =
                    'https://play.google.com/store/apps/details?id=com.fitoagricola.app&pli=1';
              } else {
                link =
                    'https://apps.apple.com/br/app/fito-agr%C3%ADcola/id6503173424';
              }

              try {
                await launchUrl(
                  Uri.parse(link),
                  mode: LaunchMode.externalApplication,
                );
              } catch (e) {
                print(e);
              }
            },
          ),
        ],
      ),
    );
  }
}
