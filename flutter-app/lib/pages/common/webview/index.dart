import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewIndex extends StatefulWidget {
  const WebViewIndex({Key? key}) : super(key: key);

  @override
  State<WebViewIndex> createState() => _WebViewIndexState();
}

class _WebViewIndexState extends State<WebViewIndex> {
  late final WebViewController _controller;
  late final String _title;

  @override
  void initState() {
    super.initState();
    final arg = (Get.arguments as Map?) ?? const {};
    final url = (arg['url'] ?? '').toString();
    _title = (arg['title'] ?? 'Web').toString();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);

    if (url.isNotEmpty) {
      _controller.loadRequest(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}