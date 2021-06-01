import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Internetview extends StatefulWidget {
  String initialUrl;

  Internetview(this.initialUrl);

  @override
  _InternetviewState createState() => _InternetviewState();
}

class _InternetviewState extends State<Internetview> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          WebView(
            //key: _key,
            initialUrl: widget.initialUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading
              ? Container(
                  color: Colors.black,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Stack(),
        ],
      ),
    );
  }
}
