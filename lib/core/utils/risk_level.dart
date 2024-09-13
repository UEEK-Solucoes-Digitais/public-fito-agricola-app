import 'package:fitoagricola/core/app_export.dart';
import 'package:flutter/material.dart';

class RiskLevel {
  static Widget convertToWidget(int? risk) {
    return Container(
      decoration: BoxDecoration(
        color: convertToColor(risk),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      child: Text(
        convertToString(risk),
        style: theme.textTheme.bodyMedium!.copyWith(
          color: appTheme.whiteA70001,
        ),
      ),
    );
  }

  static String convertToString(int? risk) {
    switch (risk) {
      case 3:
        return 'Urgência';
      case 2:
        return 'Atenção';
      case 1:
        return 'Sem risco';
      default:
        return '';
    }
  }

  static Color convertToColor(int? risk) {
    switch (risk) {
      case 3:
        return appTheme.red600;
      case 2:
        return appTheme.amber500;
      case 1:
      default:
        return appTheme.green400;
    }
  }
}
