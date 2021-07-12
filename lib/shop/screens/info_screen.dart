import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/auth.dart';
import 'package:provider/provider.dart';

class InfoScreen extends StatelessWidget {
  static const routeName = '/info';

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      body: ListView(
        children: <Widget>[
          AppBar(
              title: Text('Info Screen'),
              backgroundColor: Color(0xff262f38),
              automaticallyImplyLeading: false,
            ),
          ListTile(
            leading: Icon(Icons.payment, color: Colors.white),
            title: Text(
              'In bearbeitung....',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {},
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
    );
  }
}
