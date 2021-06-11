import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Message with ChangeNotifier {
  final String content;
  final String sendID;
  final String reciID;
  final String timestamp;
  final String id;
  bool isRead;

  Message({
    @required this.content,
    @required this.sendID,
    @required this.reciID,
    @required this.timestamp,
    @required this.id,
    this.isRead = false,
  });

  Future<void> toggleReadStatus(
      String token, String userId, String messageId, bool status) async {
    final url =
        'https://postrelais-default-rtdb.europe-west1.firebasedatabase.app/userChat/$userId/$messageId/isRead.json?auth=$token';
    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode(status),
      );
      if (response.statusCode >= 400) {
        print(response.statusCode);
      }
    } catch (error) {
      print("Error2");
    }
  }
}
