import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/auth.dart';
import 'package:flutter_lann/shop/providers/orders_state.dart';
import 'package:flutter_lann/shop/screens/products_overview.dart';
import 'package:provider/provider.dart';
import 'package:flutter_lann/shop/providers/orders.dart' show Orders;
import 'package:flutter_lann/shop/widgets/order_item.dart' as ord;

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int choiceListAktuell = 0;

  @override
  Widget build(BuildContext context) {
    final _orderState = Provider.of<OrderState>(context, listen: false);
    final _auth = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Bestellungen'),
        backgroundColor: Color(0xff262f38),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context)
                .pushReplacementNamed(ProductsOverviewScreen.routeName);
          },
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (BuildContext context) {
              return _orderState.choiceList.map((choice) {
                return PopupMenuItem(
                  value: _orderState.choiceListPosition(choice),
                  child: Text(choice),
                );
              }).toList();
            },
            onSelected: (value) {
              setState(() {
                choiceListAktuell = value;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false)
            .fetchAndSetOrders(_auth.isAdmin),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              print(dataSnapshot.error);
              // ...
              // Do error handling stuff
              return Center(
                child: Text(
                  'An error occurred!',
                  style: TextStyle(color: Colors.red),
                ),
              );
            } else {
              return RefreshIndicator(
                  onRefresh: () => Provider.of<Orders>(context, listen: false)
                      .fetchAndSetOrders(_auth.isAdmin),
                  child: Consumer<Orders>(
                      builder: (ctx, orderData, child) => ListView.builder(
                          itemCount: _orderState
                              .sortOrders(choiceListAktuell, orderData.orders)
                              .length,
                          itemBuilder: (ctx, i) {
                            if (_auth.isAdmin) {
                              return ord.OrderItemAdmin(
                                  _orderState.sortOrders(
                                      choiceListAktuell, orderData.orders)[i],
                                  orderData);
                            } else {
                              return ord.OrderItemUser(
                                  _orderState.sortOrders(
                                      choiceListAktuell, orderData.orders)[i],
                                  orderData);
                            }
                          })));
            }
          }
        },
      ),
    );
  }
}
