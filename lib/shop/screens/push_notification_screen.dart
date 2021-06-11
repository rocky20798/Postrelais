import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/auth.dart';
import 'package:flutter_lann/shop/screens/products_overview.dart';

import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class PushNotificationScreen extends StatelessWidget {
  static const routeName = '/push_notification';

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Push Notification'),
        backgroundColor: Color(0xff262f38),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context)
                .pushReplacementNamed(ProductsOverviewScreen.routeName);
          },
        ),
      ),
      body: Column(
        children: [
          Text(
            "PushNotification",
            style: TextStyle(color: Colors.red),
          ),
          TextButton(
              onPressed: () {
                sendAndRetrieveMessage(_auth.token);
              },
              child: Text("Senden", style: TextStyle(color: Colors.blue))),
        ],
      ),
    );
  }

  final String serverToken = '	AAAAi6cGVbk:APA91bETOIWzGKIjG6dN4tx5_iAoeZnTxvHlgsPj-AgsrnLzk5JkI8Zu4PuZsiyp8UxZ96AATLJx02tM-wgGujjD-Yt8WQDfLnkrPGq9Fs7WvyvP2n8twoiOJSJCiv7GjfqWmPGvtJkw ';

  Future<Map<String, dynamic>> sendAndRetrieveMessage(String token) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'Text',
            'title': 'FlutterCloudMessage'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': token,
        },
      ),
    );

    final Completer<Map<String, dynamic>> completer =
    Completer<Map<String, dynamic>>();

     /*final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );*/

    return completer.future;
  }
}
