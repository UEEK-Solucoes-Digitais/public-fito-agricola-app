import 'package:fitoagricola/core/app_export.dart';
import 'package:flutter/material.dart';

class DefaultCircularIndicator {
  static Widget getIndicator({double size = 40, Color? color}) {
    return Center(
      child: Container(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: color != null ? color : theme.colorScheme.primary,
        ),
      ),
    );
  }
}
