import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_lann/shop/providers/cart.dart';

class OrderItem {
  final String id;
  final String creatorId;
  final double amount;
  final String phonenumber;
  final List<CartItem> products;
  final DateTime dateTime;
  final String stateOrder;
  final String noteOrder;

  OrderItem(
      {@required this.id,
      @required this.creatorId,
      @required this.amount,
      @required this.phonenumber,
      @required this.products,
      @required this.dateTime,
      @required this.stateOrder,
      @required this.noteOrder});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders(bool all) async {
    String url = '';
    if (all) {
      url =
          'https://postrelais-default-rtdb.europe-west1.firebasedatabase.app/orders.json?auth=$authToken';
    } else {
      url =
          'https://postrelais-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$authToken';
    }
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      print("Data = null Orders");
      return;
    }
    //NEW
    try {
      if (all) {
        extractedData.forEach((userId, value) {
          value.forEach((orderId, orderData) {
            loadedOrders.add(
              OrderItem(
                id: orderId,
                creatorId: userId,
                amount: orderData['amount'],
                phonenumber: orderData['phonenumber'],
                dateTime: DateTime.parse(orderData['dateTime']),
                products: (orderData['products'] as List<dynamic>)
                    .map(
                      (item) => CartItem(
                        id: item['id'],
                        price: item['price'],
                        quantity: item['quantity'],
                        title: item['title'],
                      ),
                    )
                    .toList(),
                stateOrder: orderData['state'],
                noteOrder: orderData['note'],
              ),
            );
          });
        });
      } else {
        extractedData.forEach((orderId, orderData) {
          loadedOrders.add(
            OrderItem(
              id: orderId,
              amount: orderData['amount'],
              phonenumber: orderData['phonenumber'],
              dateTime: DateTime.parse(orderData['dateTime'].toString()),
              products: (orderData['products'] as List<dynamic>)
                  .map(
                    (item) => CartItem(
                      id: item['id'],
                      price: item['price'],
                      quantity: item['quantity'],
                      title: item['title'],
                    ),
                  )
                  .toList(),
              stateOrder: orderData['state'],
              noteOrder: orderData['note'],
            ),
          );
        });
      }
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total,
      String number, String state, String note) async {
    final url =
        'https://postrelais-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'amount': total,
        'phonenumber': number,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
        'state': state,
        'note': note,
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timestamp,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }

  Future<void> updateOrder(
      String userIdOther, String orderId, String state, String note, double amount) async {
    if (userIdOther == "") {
      userIdOther = userId;
    }
    final url =
        'https://postrelais-default-rtdb.europe-west1.firebasedatabase.app/orders/$userIdOther/$orderId.json?auth=$authToken';
    await http.patch(Uri.parse(url),
        body: json.encode({
          'state': state,
          'note': note,
          'amount': amount,
        }));
    notifyListeners();
  }
}
