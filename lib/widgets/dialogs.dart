import 'package:fitoagricola/widgets/custom_dialog/custom_dialog.dart';
import 'package:fitoagricola/widgets/custom_filled_button.dart';
import 'package:fitoagricola/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';

class Dialogs {
  static showLoadingDialog(context,
      {String title = "Aguarde um momento",
      String text = "Estamos deixando tudo pronto para você!"}) async {
    await showDialog<String>(
      context: context,
      barrierColor: Color.fromRGBO(6, 78, 67, 1),
      barrierDismissible: false,
      builder: (BuildContext context) => CustomDialog(
        title: title,
        text: text,
        isLoading: true,
        buttons: [
          Center(
            child: CircularProgressIndicator(),
          )
        ],
      ),
    );
  }

  static showGeralDialog(
    context, {
    String title = "",
    String text = "",
    Widget? widget,
    bool doubleClose = false,
  }) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      barrierColor: Color.fromRGBO(6, 78, 67, 1),
      builder: (BuildContext context) => CustomDialog(
        title: title,
        text: text,
        doubleClose: doubleClose,
        buttons: [widget ?? Container()],
      ),
    );
  }

  static showBuilderGeralDialog(context,
      {String title = "",
      String text = "",
      Widget? widget,
      dynamic setState}) async {
    await showDialog<String>(
      context: context,
      barrierColor: Color.fromRGBO(6, 78, 67, 1),
      barrierDismissible: false,
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (context, setState) {
        return CustomDialog(
          title: title,
          text: text,
          buttons: [widget ?? Container()],
        );
      }),
    );
  }

  static showDeleteDialog(context,
      {String title = "",
      String text = "",
      String textButton = "",
      Function()? onClick}) {
    showDialog<String>(
      context: context,
      barrierColor: Color.fromRGBO(6, 78, 67, 1),
      barrierDismissible: false,
      builder: (BuildContext context) => CustomDialog(
        title: title,
        text: text,
        buttons: [
          CustomFilledButton(
            text: textButton,
            onPressed: onClick,
          ),
          const SizedBox(height: 10),
          CustomOutlinedButton(
            text: "Cancelar",
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
