import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SwaggerIndex extends StatefulWidget {
  const SwaggerIndex({Key? key}) : super(key: key);

  @override
  State<SwaggerIndex> createState() => _SwaggerIndexState();
}

class _SwaggerIndexState extends State<SwaggerIndex> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://mouor.cn:8081/swagger-ui/index.html'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System API', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}