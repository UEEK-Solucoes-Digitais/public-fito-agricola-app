import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IframeWebView extends StatelessWidget {
  final String iframeUrl;

  IframeWebView({required this.iframeUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebView'),
      ),
      body: WebViewWidget(
        // key: _key,
        // gestureRecognizers: gestureRecognizers,
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Update loading bar.
              },
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.startsWith('https://www.youtube.com/')) {
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadHtmlString(iframeUrl).catchError((error) {
            print("ERROR");
            print(error);
          }),
      ),
    );
  }
}
