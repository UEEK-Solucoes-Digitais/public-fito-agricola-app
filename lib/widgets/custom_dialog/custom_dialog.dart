import 'dart:ui';

import 'package:fitoagricola/core/app_export.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String text;
  final List<Widget> buttons;
  final bool doubleClose;
  final bool isLoading;

  CustomDialog({
    this.title = "",
    this.text = "",
    this.buttons = const [],
    this.doubleClose = false,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: ListView(
            shrinkWrap: true,
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                title,
                                style: theme.textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.v,
                                ),
                              ),
                            ),
                            if (!isLoading)
                              IconButton(
                                icon: Icon(Icons.close),
                                color: appTheme.gray400,
                                onPressed: () {
                                  Navigator.of(context).pop();

                                  if (doubleClose) {
                                    Navigator.of(context).pop();
                                  }
                                },
                              )
                          ],
                        ),
                        const SizedBox(height: 15),
                        text != ''
                            ? Column(
                                children: [
                                  Text(
                                    text,
                                    style: theme.textTheme.displayMedium,
                                  ),
                                  const SizedBox(height: 30),
                                ],
                              )
                            : Container(),
                        Column(
                          children: buttons,
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
