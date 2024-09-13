import 'dart:io';

import 'package:fitoagricola/core/app_export.dart';
import 'package:fitoagricola/data/models/admin/admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// ignore: must_be_immutable
class ReportsCultureTable extends StatefulWidget {
  final GlobalKey globalKey;
  final String? filtersParam;

  final Function(InAppWebViewController) functionController;

  ReportsCultureTable({
    required this.filtersParam,
    required this.globalKey,
    required this.functionController,
  });

  @override
  _ReportsCultureTableState createState() => _ReportsCultureTableState();
}

class _ReportsCultureTableState extends State<ReportsCultureTable> {
  double webViewHeight = 250; // Altura inicial
  Admin admin = PrefUtils().getAdmin();

  @override
  void initState() {
    super.initState();

    print(widget.filtersParam);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: widget.globalKey,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 20.h,
        ),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Container(
            height: webViewHeight,
            child: InAppWebView(
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                transparentBackground: true,
              ),
              initialUrlRequest: URLRequest(
                url: WebUri(
                  '${dotenv.env['SYSTEM_URL']}/webview-graph/0?culture-tab=true&query=${widget.filtersParam}&admin_id=${admin.id}',
                ),
              ),
              onConsoleMessage: Platform.isIOS
                  ? null
                  : (controller, consoleMessage) {
                      if (consoleMessage.message.contains("Labels length")) {
                        final splitString = consoleMessage.message.split(":");
                        print("split: ${splitString}");
                        if (splitString.length > 1) {
                          final labelsLength = splitString[1].trim();
                          final labelsLengthInt = int.parse(labelsLength);

                          if (labelsLengthInt > 0) {
                            setState(() {
                              webViewHeight =
                                  600 + 50 + (labelsLengthInt * 50.0);
                            });
                          }
                        }
                      }
                    },
              // gestureRecognizers: Platform.isIOS ? null : gestureRecognizers,
              onContentSizeChanged:
                  (controller, oldContentSize, newContentSize) => {
                if (newContentSize.height > webViewHeight)
                  {
                    setState(() {
                      webViewHeight = newContentSize.height;
                    })
                  }
              },
              onLoadStop: (controller, url) => {
                widget.functionController(controller),
              },
            ),
          ),
        ),
      ),
    );
  }
}
