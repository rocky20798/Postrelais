import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/auth.dart';
import 'package:flutter_lann/shop/providers/cart.dart';
import 'package:flutter_lann/shop/providers/products.dart';
import 'package:flutter_lann/shop/screens/auth_screen.dart';
import 'package:flutter_lann/shop/screens/cart.dart';
import 'package:flutter_lann/shop/screens/products_overview.dart';
import 'package:flutter_lann/shop/widgets/app_drawer.dart';
import 'package:flutter_lann/shop/widgets/badge.dart';
import 'package:flutter_lann/shop/widgets/cathegory_grid.dart';
import 'package:provider/provider.dart';

class CathegorysOverviewScreen extends StatefulWidget {
  static const routeName = '/cathegory-overview';
  @override
  _CathegorysOverviewScreenState createState() =>
      _CathegorysOverviewScreenState();
}

class _CathegorysOverviewScreenState extends State<CathegorysOverviewScreen> {
  String selectedCathegory = '';

  Future<void> _refreshCathegorys(BuildContext context) async {
    await Provider.of<Cathegorys>(context, listen: false)
        .fetchAndSetCathegorys();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<Auth>(context);
    final _cathegorys = Provider.of<Cathegorys>(context, listen: false);
    return Scaffold(
            appBar: AppBar(
              title: Text('Hofladen'),
              backgroundColor: Color(0xff262f38),
              actions: <Widget>[
                _auth.isAnonym
                    ? IconButton(
                        icon: Icon(
                          Icons.shopping_cart,
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(AuthScreen.routeName);
                        },
                      )
                    : Consumer<Cart>(
                        builder: (_, cart, ch) => Badge(
                          child: ch,
                          color: Colors.red,
                          value: cart.itemCountTotal.toString(),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.shopping_cart,
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(CartScreen.routeName);
                          },
                        ),
                      ),
              ],
            ),
            drawer: _auth.isAnonym ? null : AppDrawer(),
            body: FutureBuilder(
                future: _refreshCathegorys(context),
                builder: (ctx, snapshot) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? Center(child: CircularProgressIndicator())
                        : RefreshIndicator(
                            onRefresh: () => _refreshCathegorys(context),
                            child: CathegorysGrid(),
                          )));
  }
}
