import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/message.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Messages with ChangeNotifier {
  String _authToken;
  String userId;
  List<Message> _items = [];
  List<String> _users = [];

  Messages(this._authToken, this.userId, this._items);

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
      print(_users);
      notifyListeners();
    } catch (error) {
      throw (error);
      return "Error";
    }
  }

  Future<String> fetchAndSetMessages() async {
    var url =
        'https://postrelais-default-rtdb.europe-west1.firebasedatabase.app/userChat/$userId.json?auth=$_authToken';
    try {
      final response = await http.get(Uri.parse(url));
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
          //id: messageId,
        ));
      });
      _items = loadedMessages;
      notifyListeners();
    } catch (error) {
      throw (error);
      return "Error";
    }
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
        }),
      );
      final newMessage = Message(
        content: message.content,
        sendID: message.sendID,
        reciID: message.reciID,
        timestamp: message.timestamp,
      );
      _items.add(newMessage);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  /*Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://postrelais-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
            'cathegory': newProduct.cathegory,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://postrelais-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      //throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }*/
}
