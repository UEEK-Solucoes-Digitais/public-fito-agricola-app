import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/widgets/icons/icons.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SnackbarComponent {
  static void showSnackBar(
    BuildContext context,
    String type,
    String message, {
    Duration duration = const Duration(seconds: 2),
    Function()? onClick,
  }) {
    Color backgroundColor = theme.colorScheme.primary.withOpacity(0.4);
    String icon = '';

    switch (type) {
      case 'success':
        backgroundColor = theme.colorScheme.primary;
        icon = 'check-circle';
        break;
      case 'error':
        backgroundColor = appTheme.red600;
        icon = 'x-circle';
        break;
      case 'warning':
        backgroundColor = appTheme.amber400;
        icon = 'alert';
        break;
      case 'info':
        backgroundColor = appTheme.blue600;
        icon = 'info';
        break;
      default:
        backgroundColor = theme.colorScheme.primary;
        icon = 'check';
        break;
    }

    final snackBar = SnackBar(
      showCloseIcon: true,
      clipBehavior: Clip.none,
      content: Row(
        children: [
          type == 'loading'
              ? Container(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                )
              : PhosphorIcon(
                  IconsList.getIcon(icon),
                  color: Colors.white,
                  size: 20,
                ),
          SizedBox(width: 15),
          Flexible(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      duration: duration,
      action: onClick != null
          ? SnackBarAction(
              label: 'Abrir',
              onPressed: onClick,
              backgroundColor: Colors.white,
              textColor: theme.colorScheme.primary,
            )
          : null,
    );
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
