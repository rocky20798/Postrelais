import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/auth.dart';
import 'package:flutter_lann/shop/providers/message.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Messages with ChangeNotifier {
  String _authToken;
  String userId;
  List<Message> _items = [];
  List<String> _users = [];
  bool _isAdmin;

  Messages(this._authToken, this.userId, this._items, this._isAdmin);

  List<Message> get items {
    return [..._items];
  }

  List<String> get users {
    return [..._users];
  }

  Future<String> fetchAndSetUsers() async {
    var url =
        'https://postrelais-default-rtdb.europe-west1.firebasedatabase.app/userChat.json?auth=$_authToken';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        print("Data == null Products");
        return null;
      }
      final List<String> loadedMessages = [];
      extractedData.forEach((messageId, messageData) {
        loadedMessages.add(messageId);
      });
      _users = loadedMessages;
      notifyListeners();
    } catch (error) {
      throw (error);
      return "Error";
    }
  }

  Future<String> fetchAndSetMessages() async {
    if (_authToken == null) {
      return null;
    }
    var url =
        'https://postrelais-default-rtdb.europe-west1.firebasedatabase.app/userChat/$userId.json?auth=$_authToken';
    try {
      final response = await http.get(Uri.parse(url));
      if (response == null) {
        return null;
      }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        print("Data == null Products");
        return null;
      }
      final List<Message> loadedMessages = [];
      extractedData.forEach((messageId, messageData) {
        loadedMessages.add(Message(
            content: messageData['content'],
            reciID: messageData['reciID'],
            sendID: messageData['sendID'],
            timestamp: messageData['timestamp'],
            id: messageId,
            isRead: isReadTest(
                messageData['isRead'], messageData['reciID'], messageId)));
      });
      if (_items != loadedMessages) {
        _items = loadedMessages;
        notifyListeners();
      }
    } catch (error) {
      throw (error);
      return "Error";
    }
  }

  bool isReadTest(bool input, String reciID, String messageID) {
    bool output = false;
    if (input) {
      output = input;
    } else {
      if (reciID == userId) {
        output = true;
      } else {
        if (_isAdmin && reciID == "Admin") {
          output = true;
        } else {
          output = false;
        }
      }
    }
    if (output) {
      Message().toggleReadStatus(_authToken, userId, messageID, output);
    }
    return output;
  }

  Future<void> addMessage(Message message) async {
    final url =
        'https://postrelais-default-rtdb.europe-west1.firebasedatabase.app/userChat/$userId.json?auth=$_authToken';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'content': message.content,
          'sendID': message.sendID,
          'reciID': message.reciID,
          'timestamp': message.timestamp,
          'isRead': false
        }),
      );
      final newMessage = Message(
          content: message.content,
          sendID: message.sendID,
          reciID: message.reciID,
          timestamp: message.timestamp,
          isRead: false);
      _items.add(newMessage);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
