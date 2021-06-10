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

  void _setReadValue(bool newValue) {
    isRead = newValue;
    notifyListeners();
  }

  Future<void> toggleReadStatus(
      String token, String userId, String messageId) async {
    final oldStatus = isRead;
    isRead = !isRead;
    notifyListeners();
    final url =
        'https://postrelais-default-rtdb.europe-west1.firebasedatabase.app/userChat/$userId/$messageId.json?auth=$token';
    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode(
          isRead,
        ),
      );
      if (response.statusCode >= 400) {
        _setReadValue(oldStatus);
        print(response.statusCode);
      }
    } catch (error) {
      _setReadValue(oldStatus);
      print("Error2");
    }
  }
}
