import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CibilHtmlViewer extends StatefulWidget {
  final String htmlFileBase64;
  const CibilHtmlViewer({super.key, required this.htmlFileBase64});

  @override
  State<CibilHtmlViewer> createState() => CibilHtmlViewerState();
}

class CibilHtmlViewerState extends State<CibilHtmlViewer> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    final htmlContent = utf8.decode(base64.decode(widget.htmlFileBase64));

    controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadHtmlString(htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CIBIL Report'),
        backgroundColor: Colors.teal,
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
