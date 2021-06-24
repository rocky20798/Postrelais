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

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/products-overview';
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<Auth>(context);
    final _cathegorys = Provider.of<Cathegorys>(context, listen: false);
    final selectedCathegory =
        ModalRoute.of(context).settings.arguments as String; 
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
                  _showOnlyFavorites = !_showOnlyFavorites;
                });
              },
            ),
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
                        Navigator.of(context).pushNamed(CartScreen.routeName);
                      },
                    ),
                  ),
          ],
        ),
        //drawer: _auth.isAnonym ? null : AppDrawer(),
        body: FutureBuilder(
            future: _refreshProducts(context),
            builder: (ctx, snapshot) => snapshot.connectionState ==
                    ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: ProductsGrid(_showOnlyFavorites, selectedCathegory),
                  )));
  }
}
