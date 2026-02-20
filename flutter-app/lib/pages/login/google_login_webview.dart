import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// WebView page for Google OAuth login.
class GoogleLoginWebView extends StatefulWidget {
  const GoogleLoginWebView({Key? key}) : super(key: key);

  @override
  State<GoogleLoginWebView> createState() => _GoogleLoginWebViewState();
}

class _GoogleLoginWebViewState extends State<GoogleLoginWebView> {
  late final String _url;
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    _url = (args is Map)
        ? ((args['authUrl'] ?? args['url'])?.toString() ?? '')
        : '';

    if (_url.isNotEmpty) {
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest: (NavigationRequest request) {
              final uri = Uri.tryParse(request.url);
              if (uri != null &&
                  (uri.path.contains('google-login') || request.url.contains('google-login')) &&
                  uri.queryParameters.containsKey('code')) {
                final code = uri.queryParameters['code']?.trim();
                if (code != null && code.isNotEmpty) {
                  Get.back(result: code);
                }
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(_url));

      if (defaultTargetPlatform == TargetPlatform.android) {
        controller.setUserAgent(
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
          '(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        );
      }

      _controller = controller;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Login', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
      ),
      body: _url.isEmpty || _controller == null
          ? const Center(child: Text('No auth URL'))
          : WebViewWidget(controller: _controller!),
    );
  }
}