import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Info extends StatefulWidget{
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Info>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: _buildWebView(),
    );
  }

  Widget _buildWebView() {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl: 'https://postrelais.aedesit.com/',
    );
  }
}