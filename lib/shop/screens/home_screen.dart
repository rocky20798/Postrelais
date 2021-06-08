import 'package:flutter/material.dart';
import 'package:flutter_lann/pages/chat.dart';
import 'package:flutter_lann/pages/dashboard.dart';
import 'package:flutter_lann/shop/providers/auth.dart';
import 'package:flutter_lann/shop/providers/interentview.dart';
import 'package:flutter_lann/shop/providers/messages.dart';
import 'package:flutter_lann/shop/screens/auth_screen.dart';
import 'package:flutter_lann/shop/screens/cart.dart';
import 'package:flutter_lann/shop/screens/chat_screen.dart';
import 'package:flutter_lann/shop/screens/chat_screen_overview.dart';
import 'package:flutter_lann/shop/screens/orders.dart';
import 'package:flutter_lann/shop/screens/products_overview.dart';
import 'package:flutter_lann/shop/screens/splash-screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  int _selectedIndex;
  int _unterMenuIndex;
  String _internetAdress;

  HomeScreen(this._selectedIndex, this._internetAdress, this._unterMenuIndex);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _oldIndex = 10;

  @override
  Widget build(BuildContext context) {
    final _messages = Provider.of<Messages>(context, listen: false);
    final _auth = Provider.of<Auth>(context, listen: false);

    return Scaffold(
      bottomNavigationBar: bottomNavigationBar(),
      body: widget._selectedIndex == 0
          ? widget._internetAdress == null
              ? Dashboard()
              : Internetview(widget._internetAdress)
          : widget._selectedIndex == 1
              ? shopSide()
              : widget._selectedIndex == 3
                  ? _auth.isAdmin && widget._unterMenuIndex != 2
                      ? FutureBuilder(
                          future: _messages.fetchAndSetUsers(),
                          builder: (ctx, authResultSnapshot) =>
                              authResultSnapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? SplashScreen()
                                  : ChatScreenOverview(),
                        )
                      : FutureBuilder(
                          future: _messages.fetchAndSetMessages(),
                          builder: (ctx, authResultSnapshot) =>
                              authResultSnapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? SplashScreen()
                                  : ChatScreen(),
                        )
                  : AuthScreen(),
    );
  }

  Widget shopSide() {
    if (widget._unterMenuIndex == 0 || widget._unterMenuIndex == null) {
      return ProductsOverviewScreen();
    } else if (widget._unterMenuIndex == 1) {
      return CartScreen();
    } else if (widget._unterMenuIndex == 2) {
      return OrdersScreen();
    }
  }

  Widget bottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Color(0xff262f38),
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard, color: Color(0xffc9a42c)),
          label: 'Aktivitäten',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shop, color: Color(0xffc9a42c)),
          label: 'Shop',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.login, color: Color(0xffc9a42c)),
          label: 'Profil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message, color: Color(0xffc9a42c)),
          label: 'Chat',
        ),
      ],
      currentIndex: widget._selectedIndex,
      selectedItemColor: Color(0xffc9a42c),
      unselectedItemColor: Colors.blueGrey,
      onTap: (int index) => setState(() {
        widget._selectedIndex = index;
        widget._internetAdress = null;
      }),
    );
  }
}
