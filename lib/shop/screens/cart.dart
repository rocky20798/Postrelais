import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/auth.dart';
import 'package:flutter_lann/shop/providers/cart.dart' show Cart;
import 'package:flutter_lann/shop/providers/orders.dart';
import 'package:flutter_lann/shop/screens/orders.dart';
import 'package:flutter_lann/shop/widgets/cart_item.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';

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
  //Payment
  Token _paymentToken;
  String _error;
  ScrollController _controller = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  //Order Button
  var _isLoading = false;
  //Online Payment
  @override
  initState() {
    super.initState();
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51Ig7kCFkGG6IvAqsjOIPkR9O6P72y8FM0ZiTYaPazU1T9z9b2iRkyjXM9Z3DjHXtziQauKOPmqMzmc0KaxrU62QW00qMTWVSN4",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  void setError(dynamic error) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text(error.toString())));
    setState(() {
      _error = error.toString();
    });
  }

  //Oder Button
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('Bestellen', style: TextStyle(color: Colors.white),),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () {
              setState(() {
                _paymentToken = null;
              });
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

  void payment() {
    if (Platform.isIOS) {
      _controller.jumpTo(450);
    }
    StripePayment.paymentRequestWithNativePay(
      androidPayOptions: AndroidPayPaymentRequest(
        totalPrice: widget.cart.totalAmount.toStringAsFixed(2),
        currencyCode: "EUR",
      ),
      applePayOptions: ApplePayPaymentOptions(
        countryCode: 'DE',
        currencyCode: 'EUR',
        items: [
          ApplePayItem(
            label: 'Test',
            amount: widget.cart.totalAmount.toStringAsFixed(2),
          )
        ],
      ),
    ).then((token) {
      setState(() {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Received ${token.tokenId}')));
        _paymentToken = token;
        addOrder();
      });
    }).catchError(setError);
  }
}
