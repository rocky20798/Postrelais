import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/orders.dart' as ord;
import 'package:flutter_lann/shop/providers/orders_state.dart';
import 'package:flutter_lann/shop/screens/orders.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderItemUser extends StatefulWidget {
  final ord.OrderItem order;
  final ord.Orders orders;

  OrderItemUser(this.order, this.orders);

  @override
  _OrderItemUserState createState() => _OrderItemUserState();
}

class _OrderItemUserState extends State<OrderItemUser> {
  var _expanded = false;

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
          if (widget.order.stateOrder == _orderState.choiceListName(3) || widget.order.stateOrder == _orderState.choiceListName(4))
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
                          buttonClick(2);
                        });
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
          if (widget.order.stateOrder == _orderState.choiceListName(1) || widget.order.stateOrder == _orderState.choiceListName(3))
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
        _orderState.choiceListDesc[pos]);
    Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
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
  final myController = TextEditingController();

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
                        buttonClick(4, null);
                      });
                    }),
                IconButton(
                    icon: Icon(Icons.done_all),
                    color: Colors.green,
                    onPressed: () {
                      setState(() {
                        buttonClick(5, null);
                      });
                    }),
                IconButton(
                    icon: Icon(Icons.payments),
                    color: Colors.purple,
                    onPressed: () {
                      setState(() {
                        buttonClick(2, null);
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
                        buttonClick(6, null);
                      });
                    }),
                IconButton(
                    icon: Icon(Icons.auto_delete),
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        buttonClick(7, null);
                      });
                    }),
              ],
            ),
          if (_expanded && _expanded2)
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 7,
                  child: TextFormField(
                    controller: myController,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                        setState(() {
                          buttonClick(3, myController.text);
                          _expanded2 = false;
                        });
                      }),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void buttonClick(int pos, String text) {
    final _orderState = Provider.of<OrderState>(context, listen: false);
    widget.orders.updateOrder(widget.order.creatorId, widget.order.id, _orderState.choiceList[pos],
        text == null ? _orderState.choiceListDesc[pos] : text);
    //Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
  }
}
