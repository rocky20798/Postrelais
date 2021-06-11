import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/auth.dart';
import 'package:flutter_lann/shop/screens/orders.dart';
import 'package:flutter_lann/shop/screens/push_notification_screen.dart';
import 'package:flutter_lann/shop/screens/user_products.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<Auth>(context, listen: false);
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
            if (_auth.isAdmin) Divider(color: Colors.white),
            if (_auth.isAdmin)
              ListTile(
                leading: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
                title: Text(
                  'Push Notification',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(PushNotificationScreen.routeName);
                },
              ),
            if (_auth.isAdmin) Divider(color: Colors.white),
            if (_auth.isAdmin)
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
            Divider(
              color: Colors.white,
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.white),
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                _auth.logout();
                _auth.signInAnonymously();
              },
            ),
          ],
        ),
      ),
    );
  }
}
