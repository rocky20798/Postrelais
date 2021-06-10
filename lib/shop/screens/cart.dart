import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/auth.dart';
import 'package:flutter_lann/shop/providers/cart.dart' show Cart;
import 'package:flutter_lann/shop/providers/orders.dart';
import 'package:flutter_lann/shop/screens/orders.dart';
import 'package:flutter_lann/shop/widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Warenkorb'),
        backgroundColor: Color(0xff262f38),
      ),
      body: Column(
        children: <Widget>[
          Card(
            color: Colors.blueGrey,
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Gesamt:',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '${cart.totalAmount.toStringAsFixed(2)}€',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    backgroundColor: Color(0xffc9a42c),
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) => CartItem(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
                cart.items.values.toList()[i].title,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  //Order Button
  var _isLoading = false;

  //Oder Button
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('Bestellen', style: TextStyle(color: Colors.white),),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () {
              addOrder();
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
      textColor: Colors.white,
    );
  }

  Future<void> addOrder() async {
    setState(() {
      _isLoading = true;
    });
    final auth = Provider.of<Auth>(context, listen: false);
    await Provider.of<Orders>(context, listen: false).addOrder(
        widget.cart.items.values.toList(),
        widget.cart.totalAmount,
        auth.phoneNumber,
        "Erstellt",
        "Die Bestellung muss noch vom Personal überprüft werden");
    setState(() {
      _isLoading = false;
    });
    widget.cart.clear();
  }
}
