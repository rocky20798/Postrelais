import 'package:flutter/material.dart';
import 'package:flutter_lann/shop/providers/auth.dart';
import 'package:flutter_lann/shop/providers/cart.dart';
import 'package:flutter_lann/shop/providers/products.dart';
import 'package:flutter_lann/shop/screens/auth_screen.dart';
import 'package:flutter_lann/shop/screens/cart.dart';
import 'package:flutter_lann/shop/widgets/app_drawer.dart';
import 'package:flutter_lann/shop/widgets/badge.dart';
import 'package:flutter_lann/shop/widgets/product_grid.dart';
import 'package:provider/provider.dart';

Future<void> _refreshProducts(BuildContext context) async {
  if (await Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts() ==
      "Error") {
    Auth _auth = new Auth();
    _auth.logout();
    Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
  }
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/product-overview';
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _showOnlyCathegory = '';

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<Auth>(context);
    final _products = Provider.of<Products>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text('Hofladen'),
          backgroundColor: Color(0xff262f38),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                _showOnlyFavorites ? Icons.favorite : Icons.favorite_border,
              ),
              color: Colors.red,
              onPressed: () {
                setState(() {
                  _showOnlyCathegory = '';
                  _showOnlyFavorites = !_showOnlyFavorites;
                });
              },
            ),
            PopupMenuButton(
              icon: Icon(
                Icons.more_vert,
              ),
              itemBuilder: (BuildContext context) {
                return _products.cathegory.map((choice) {
                  return PopupMenuItem(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
              onSelected: (value) {
                setState(() {
                  if (_products.cathegory.indexOf(value) == 0) {
                    _showOnlyCathegory = '';
                  } else {
                    _showOnlyCathegory = value;
                  }
                });
              },
            ),
            _auth.isAnonym
                ? IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                    ),
                    onPressed: () {
                      _auth.logout();
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
                        Navigator.of(context).pushNamed(CartScreen.routeName);
                      },
                    ),
                  ),
          ],
        ),
        drawer: AppDrawer(_auth.isAdmin, _auth.isAnonym),
        body: FutureBuilder(
            future: _refreshProducts(context),
            builder: (ctx, snapshot) => snapshot.connectionState ==
                    ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: ProductsGrid(_showOnlyFavorites, _showOnlyCathegory),
                  )));
  }
}
