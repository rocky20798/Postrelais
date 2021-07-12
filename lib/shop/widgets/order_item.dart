import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/orders.dart' as ord;
import 'package:flutter_lann/shop/providers/orders_state.dart';
import 'package:flutter_lann/shop/screens/orders.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';

class OrderItemUser extends StatefulWidget {
  final ord.OrderItem order;
  final ord.Orders orders;

  OrderItemUser(this.order, this.orders);

  @override
  _OrderItemUserState createState() => _OrderItemUserState();
}

class _OrderItemUserState extends State<OrderItemUser> {
  var _expanded = false;
  //Payment
  Token _paymentToken;
  String _error;
  ScrollController _controller = ScrollController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  //Online Payment
  @override
  initState() {
    super.initState();
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_live_51HyIjKFJRmSJXBRaTU6ftoDoxeyHf9NIM6OdVrB9MONjsFwIQtF9vP64uo6i3XrjCPd71sMOHLwFc72Bqe1qrrEJ00OzAx6bso",
        merchantId: "Postrelais App",
        androidPayMode: 'Karte'));
  }

  void setError(dynamic error) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text(error.toString())));
    setState(() {
      _error = error.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _orderState = Provider.of<OrderState>(context, listen: false);
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('${widget.order.amount.toStringAsFixed(2)}€'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
                ),
                Text(
                  '${widget.order.stateOrder}',
                  style: TextStyle(
                      color:
                          _orderState.getMessageColor(widget.order.stateOrder)),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded && widget.order.noteOrder != null)
            Text(
              '${widget.order.noteOrder}',
              style: TextStyle(
                  color: _orderState.getMessageColor(widget.order.stateOrder)),
            ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: widget.order.products.length * 45.0 + 10.0,
              child: ListView(
                children: widget.order.products
                    .map((prod) => Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  prod.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${prod.quantity}x ${prod.price.toStringAsFixed(2)}€',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                            Divider(),
                          ],
                        ))
                    .toList(),
              ),
            ),
          if (widget.order.stateOrder == _orderState.choiceListName(3) ||
              widget.order.stateOrder == _orderState.choiceListName(4))
            Row(
              children: [
                Expanded(
                  child: Column(),
                  flex: 1,
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    "Online bezahlen",
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: IconButton(
                      icon: Icon(Icons.payments),
                      color: Colors.purple,
                      onPressed: () {
                        setState(() {
                          _paymentToken = null;
                        });
                        payment();
                      }),
                ),
              ],
            ),
          if (widget.order.stateOrder == _orderState.choiceListName(2))
            Row(
              children: [
                Expanded(
                  child: Column(),
                  flex: 1,
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    "Bestellung erhalten",
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: IconButton(
                      icon: Icon(Icons.check),
                      color: Colors.purple,
                      onPressed: () {
                        setState(() {
                          buttonClick(5);
                        });
                      }),
                ),
              ],
            ),
          if (widget.order.stateOrder == _orderState.choiceListName(1) ||
              widget.order.stateOrder == _orderState.choiceListName(3))
            Row(
              children: [
                Expanded(
                  child: Column(),
                  flex: 1,
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    "Bestellung stonieren",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: IconButton(
                      icon: Icon(Icons.cancel),
                      color: Colors.red,
                      onPressed: () {
                        setState(() {
                          buttonClick(6);
                        });
                      }),
                ),
              ],
            )
        ],
      ),
    );
  }

  void buttonClick(int pos) {
    final _orderState = Provider.of<OrderState>(context, listen: false);
    widget.orders.updateOrder("", widget.order.id, _orderState.choiceList[pos],
        _orderState.choiceListDesc[pos], widget.order.amount);
    Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
  }

  void payment() {
    if (Platform.isIOS) {
      _controller.jumpTo(450);
    }
    StripePayment.paymentRequestWithNativePay(
      androidPayOptions: AndroidPayPaymentRequest(
        totalPrice: widget.order.amount.toStringAsFixed(2),
        currencyCode: "EUR",
      ),
      applePayOptions: ApplePayPaymentOptions(
        countryCode: 'DE',
        currencyCode: 'EUR',
        items: [
          ApplePayItem(
            label: widget.order.dateTime.toIso8601String(),
            amount: widget.order.amount.toStringAsFixed(2),
          )
        ],
      ),
    ).then((token) {
      setState(() {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Received ${token.tokenId}')));
        _paymentToken = token;
        buttonClick(2);
      });
    }).catchError(setError);
  }
}

class OrderItemAdmin extends StatefulWidget {
  final ord.OrderItem order;
  final ord.Orders orders;

  OrderItemAdmin(this.order, this.orders);

  @override
  _OrderItemAdminState createState() => _OrderItemAdminState();
}

class _OrderItemAdminState extends State<OrderItemAdmin> {
  var _expanded = false;
  var _expanded2 = false;
  final myController_text = TextEditingController();
  final myController_preis = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _orderState = Provider.of<OrderState>(context);
    return Card(
      color: Colors.blueGrey,
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('${widget.order.amount.toStringAsFixed(2)}€'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
                ),
                Text('${widget.order.phonenumber}'),
                Text(
                  '${widget.order.stateOrder}',
                  style: TextStyle(
                      color:
                          _orderState.getMessageColor(widget.order.stateOrder)),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded && widget.order.noteOrder != null)
            Text(
              '${widget.order.noteOrder}',
              style: TextStyle(
                  color: _orderState.getMessageColor(widget.order.stateOrder)),
            ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: widget.order.products.length * 45.0 + 10.0,
              child: ListView(
                children: widget.order.products
                    .map((prod) => Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  prod.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${prod.quantity}x ${prod.price.toStringAsFixed(2)}€',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                            Divider(),
                          ],
                        ))
                    .toList(),
              ),
            ),
          if (_expanded)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: Icon(Icons.done),
                    color: Colors.green,
                    onPressed: () {
                      setState(() {
                        buttonClick(4, null, 0.0);
                      });
                    }),
                IconButton(
                    icon: Icon(Icons.done_all),
                    color: Colors.green,
                    onPressed: () {
                      setState(() {
                        buttonClick(5, null, 0.0);
                      });
                    }),
                IconButton(
                    icon: Icon(Icons.payments),
                    color: Colors.purple,
                    onPressed: () {
                      setState(() {
                        buttonClick(2, null, 0.0);
                      });
                    }),
                IconButton(
                    icon: Icon(Icons.report),
                    color: Colors.orange,
                    onPressed: () {
                      setState(() {
                        _expanded2 = !_expanded2;
                      });
                    }),
                IconButton(
                    icon: Icon(Icons.close),
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        buttonClick(6, null, 0.0);
                      });
                    }),
                IconButton(
                    icon: Icon(Icons.auto_delete),
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        buttonClick(7, null, 0.0);
                      });
                    }),
              ],
            ),
          if (_expanded && _expanded2)
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 7,
                      child: TextFormField(
                        decoration: InputDecoration(hintText: "Nachricht"),
                        controller: myController_text,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 7,
                      child: TextFormField(
                        decoration: InputDecoration(hintText: "Neuer Preis"),
                        keyboardType: TextInputType.number,
                        controller: myController_preis,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            setState(() {
                              if (myController_preis.text == "") {
                                buttonClick(3, myController_text.text, 0.0);
                              } else {
                                buttonClick(3, myController_text.text,
                                    double.parse(myController_preis.text));
                              }
                              _expanded2 = false;
                            });
                          }),
                    ),
                  ],
                ),
              ],
            )
        ],
      ),
    );
  }

  void buttonClick(int pos, String text, double amount) {
    final _orderState = Provider.of<OrderState>(context, listen: false);
    widget.orders.updateOrder(
        widget.order.creatorId,
        widget.order.id,
        _orderState.choiceList[pos],
        text == null ? _orderState.choiceListDesc[pos] : text,
        amount == 0.0 ? widget.order.amount : amount);
    //Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
  }
}
