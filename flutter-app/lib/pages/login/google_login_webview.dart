import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// WebView page for Google OAuth login.
/// Loads auth URL; when Google redirects to redirect_uri (e.g. .../google-login?code=xxx),
/// intercepts the URL, extracts the code, and returns it to the login page via Get.back(result: code).
class GoogleLoginWebView extends StatelessWidget {
  const GoogleLoginWebView({Key? key}) : super(key: key);

  /// Intercept navigation: if URL is the OAuth callback (contains "google-login" and "code="),
  /// parse the code and close this page with the code so the login page can exchange it for a token.
  static NavigationDecision _onNavigationRequest(NavigationRequest request) {
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
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final url = (args is Map)
        ? ((args['authUrl'] ?? args['url'])?.toString() ?? '')
        : '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Login', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
      ),
      body: url.isEmpty
          ? const Center(child: Text('No auth URL'))
          : WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: url,
              navigationDelegate: _onNavigationRequest,
            ),
    );
  }
}
