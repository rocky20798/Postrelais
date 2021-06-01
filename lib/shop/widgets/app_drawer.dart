import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/screens/orders.dart';
import 'package:flutter_lann/shop/screens/user_products.dart';

class AppDrawer extends StatelessWidget {
  final bool _admin;

  AppDrawer(this._admin);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black,
        child: ListView(
          children: <Widget>[
            AppBar(
              title: Text('Hoflanden'),
              backgroundColor: Color(0xff262f38),
              automaticallyImplyLeading: false,
            ),
            ListTile(
              leading: Icon(Icons.payment, color: Colors.white),
              title: Text(
                'Bestellungen',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.routeName);
              },
            ),
            if (_admin) Divider(color: Colors.white),
            if (_admin)
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                title: Text(
                  'Produkte bearbeiten',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(UserProductsScreen.routeName);
                },
              ),
          ],
        ),
      ),
    );
  }
}
