import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/auth.dart';
import 'package:flutter_lann/shop/screens/orders.dart';
import 'package:flutter_lann/shop/screens/user_products.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  final bool _admin;
  final bool _anonym;

  AppDrawer(this._admin, this._anonym);

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
            if (!_anonym)
              ListTile(
                leading: Icon(Icons.payment, color: Colors.white),
                title: Text('Bestellungen', style: TextStyle(color: Colors.white),),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(OrdersScreen.routeName);
                },
              ),
            if (_admin) Divider(color: Colors.white),
            if (_admin)
              ListTile(
                leading: Icon(Icons.edit, color: Colors.white,),
                title: Text('Produkte bearbeiten', style: TextStyle(color: Colors.white),),
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
